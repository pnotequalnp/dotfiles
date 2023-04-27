fn main() -> Result<(), Box<dyn std::error::Error>> {
    let socket = {
        let instance = std::env::var("HYPRLAND_INSTANCE_SIGNATURE")?;
        let path = format!("/tmp/hypr/{instance}/.socket2.sock");
        let socket = std::os::unix::net::UnixStream::connect(path)?;
        std::io::BufReader::new(socket)
    };

    struct Monitor {
        name: String,
        active: usize,
    }

    let (mut active_monitor, mut monitors) = {
        let output = std::process::Command::new("hyprctl")
            .arg("-j")
            .arg("monitors")
            .stdout(std::process::Stdio::piped())
            .spawn()?
            .stdout
            .expect("failed to read hyprctl stdout");

        #[derive(serde::Deserialize)]
        struct ActiveWorkspace {
            id: usize,
        }

        #[allow(non_snake_case)]
        #[derive(serde::Deserialize)]
        struct HyprctlMonitor {
            name: String,
            activeWorkspace: ActiveWorkspace,
            focused: bool,
        }

        let output: Vec<HyprctlMonitor> = serde_json::from_reader(output)?;
        let active_monitor = output
            .iter()
            .find_map(|m| m.focused.then(|| m.name.clone()))
            .expect("no monitors");
        let monitors = output
            .into_iter()
            .map(|m| Monitor {
                name: m.name,
                active: m.activeWorkspace.id - 1,
            })
            .collect::<Vec<_>>();

        (active_monitor, monitors)
    };

    #[derive(serde::Serialize)]
    struct Workspace {
        id: usize,
        active: bool,
    }

    let mut workspaces = (1..=20)
        .map(|id| {
            let active = monitors.iter().any(|m| id == m.active);
            Workspace { id, active }
        })
        .collect::<Vec<_>>();

    use std::io::prelude::*;

    let mut stdout = std::io::stdout().lock();

    if let Err(err) = serde_json::to_writer(&mut stdout, &workspaces) {
        eprintln!("failed to write output: {err}");
    }
    if let Err(err) = write!(&mut stdout, "\n") {
        eprintln!("failed to write to stdout: {err}");
    }

    for line in socket.lines() {
        let line = line?;
        match Event::parse(&line) {
            None => eprintln!("unknown event: {line}"),
            Some(event) => match event {
                Event::Workspace { id } => {
                    workspaces[id].active = true;
                    if let Some(m) = monitors.iter_mut().find(|m| m.name == active_monitor) {
                        workspaces[m.active].active = false;
                        m.active = id;
                    }
                }
                Event::FocusedMon { monitor, workspace } => {
                    active_monitor = monitor.to_string();
                    workspaces[workspace].active = true;
                    if let Some(m) = monitors.iter_mut().find(|m| m.name == active_monitor) {
                        workspaces[m.active].active = false;
                        m.active = workspace;
                    }
                }
            },
        };

        if let Err(err) = serde_json::to_writer(&mut stdout, &workspaces) {
            eprintln!("failed to write output: {err}");
        }
        if let Err(err) = write!(&mut stdout, "\n") {
            eprintln!("failed to write to stdout: {err}");
        }
    }

    Ok(())
}

enum Event<'a> {
    Workspace { id: usize },
    FocusedMon { monitor: &'a str, workspace: usize },
}

impl Event<'_> {
    fn parse(str: &str) -> Option<Event<'_>> {
        use Event::*;

        match str.split(">>").collect::<Vec<_>>()[..] {
            ["workspace", id] => {
                let id: usize = id.parse().ok()?;
                Some(Workspace { id: id - 1 })
            }
            ["focusedmon", data] => match data.split(",").collect::<Vec<_>>()[..] {
                [monitor, workspace] => {
                    let workspace: usize = workspace.parse().ok()?;
                    Some(FocusedMon {
                        monitor,
                        workspace: workspace - 1,
                    })
                }
                _ => None,
            },
            _ => None,
        }
    }
}
