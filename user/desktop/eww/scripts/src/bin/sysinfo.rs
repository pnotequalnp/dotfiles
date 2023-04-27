fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();

    SysMonitor::new()?.poll(Duration::from_millis(args.interval))
}

use clap::Parser;
use serde::Serialize;
use std::time::Duration;

macro_rules! env_color {
    ($x:ident) => {
        const $x: Color = match Color::parse(env!(stringify!($x))) {
            None => panic!("Failed to parse color from environment"),
            Some(color) => color,
        };
    };
}

#[derive(Parser)]
struct Args {
    #[arg(help = "Interval between updates in milliseconds")]
    interval: u64,
}

#[derive(Default, Serialize)]
struct Temp {
    current: f32,
    critical: f32,
    percent: f32,
    color: String,
}

#[derive(Default, Serialize)]
struct Battery {
    percent: f32,
    state: String,
    color: String,
}

#[derive(Default, Serialize)]
struct SysInfo {
    temp: Temp,
    batteries: Vec<Battery>,
}

#[derive(Debug)]
pub struct SysMonitor {
    thermal: sysinfo::Component,
    battery_manager: starship_battery::Manager,
    batteries: Vec<starship_battery::Battery>,
}

impl SysMonitor {
    pub fn new() -> Result<Self, Box<dyn std::error::Error>> {
        use sysinfo::{ComponentExt, SystemExt};

        if !sysinfo::System::IS_SUPPORTED {
            return Err("unsupported system".into());
        }

        let mut sys = sysinfo::System::new();

        sys.refresh_components_list();
        let thermal = sys
            .components_mut()
            .iter_mut()
            .find_map(|comp| comp.label().find("acpitz").map(|_| std::mem::take(comp)));
        let thermal = match thermal {
            Some(component) => component,
            None => return Err("failed to find acpitz device".into()),
        };

        let battery_manager = starship_battery::Manager::new()?;
        let batteries = battery_manager.batteries()?.collect::<Result<_, _>>()?;

        Ok(Self {
            thermal,
            battery_manager,
            batteries,
        })
    }

    pub fn poll(mut self, interval: Duration) -> ! {
        use std::io::Write;
        use sysinfo::ComponentExt;

        let mut stdout = std::io::stdout().lock();

        let mut info = SysInfo::default();
        info.temp.critical = self.thermal.critical().unwrap_or(100.);

        loop {
            {
                env_color!(CRITICAL_COLOR);
                self.thermal.refresh();
                info.temp.current = self.thermal.temperature();
                let ratio = info.temp.current / info.temp.critical;
                info.temp.percent = 100. * ratio;
                info.temp.color = CRITICAL_COLOR.desaturate(ratio.powi(3)).to_string();
            }

            info.batteries = self
                .batteries
                .iter_mut()
                .map(|bat| {
                    if let Err(err) = self.battery_manager.refresh(bat) {
                        eprintln!("failed to refresh battery status: {err}");
                    }
                    read_battery(bat)
                })
                .collect();

            if let Err(err) = serde_json::to_writer(&mut stdout, &info) {
                eprintln!("failed to write system information: {err}");
            }

            if let Err(err) = write!(&mut stdout, "\n") {
                eprintln!("failed to write to stdout: {err}");
            }

            std::thread::sleep(interval);
        }
    }
}

#[derive(Clone, Copy)]
struct Color {
    red: u8,
    green: u8,
    blue: u8,
}

impl Color {
    const fn parse(s: &str) -> Option<Self> {
        const fn hex_val(x: u8) -> u8 {
            match x {
                0x30..=0x39 => x - 0x30,
                0x41..=0x46 => x - 0x41 + 0xA,
                _ => x - 0x61 + 0xA,
            }
        }

        macro_rules! hex { () => { (0x30..=0x39 | 0x41..=0x46 | 0x61..=0x66) } }

        match s.as_bytes() {
            [b'#', r0 @ hex!(), r1 @ hex!(), g0 @ hex!(), g1 @ hex!(), b0 @ hex!(), b1 @ hex!()] => {
                Some(Self {
                    red: hex_val(*r0) * 0x10 + hex_val(*r1),
                    green: hex_val(*g0) * 0x10 + hex_val(*g1),
                    blue: hex_val(*b0) * 0x10 + hex_val(*b1),
                })
            }
            _ => None,
        }
    }

    fn desaturate(self, ratio: f32) -> Self {
        let Self { red, green, blue } = self;
        Self {
            red: (red as f32 * ratio).round() as u8,
            green: (green as f32 * ratio).round() as u8,
            blue: (blue as f32 * ratio).round() as u8,
        }
    }

    fn to_string(self) -> String {
        let Self { red, green, blue } = self;
        format!("#{red:02x}{green:02x}{blue:02x}")
    }
}

fn read_battery(battery: &starship_battery::Battery) -> Battery {
    use starship_battery::State::*;

    env_color!(CHARGING_COLOR);
    env_color!(DISCHARGING_COLOR);
    env_color!(EMPTY_COLOR);
    env_color!(FULL_COLOR);
    env_color!(UNKNOWN_COLOR);

    let ratio: f32 = battery.state_of_charge().into();
    let state = battery.state();
    let color = match state {
        Unknown => UNKNOWN_COLOR,
        Empty => EMPTY_COLOR,
        Discharging => DISCHARGING_COLOR.desaturate((1. - ratio).sqrt()),
        Charging => CHARGING_COLOR.desaturate(ratio),
        Full => FULL_COLOR,
    };

    Battery {
        percent: ratio * 100.,
        state: state.to_string(),
        color: color.to_string(),
    }
}
