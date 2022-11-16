{ pkgs, config, ... }:

{
  home.packages = [ pkgs.neofetch ];
  xdg.configFile."neofetch/config.conf".text = ''
    print_info() {
        info "OS" distro
        info "Kernel" kernel
        info "Shell" shell
        info "Packages" packages
        info "Terminal" term
        info "Terminal Font" term_font
        info "DE" de
        info "WM" wm
        info "WM Theme" wm_theme
        info "Theme" theme
        info "Icons" icons
        info "CPU" cpu
        info "GPU" gpu
        info "Memory" memory
        info "Disk" disk
        info "Resolution" resolution
        info cols
    }

    kernel_shorthand="on"
    distro_shorthand="off"
    os_arch="on"
    uptime_shorthand="off"
    memory_percent="off"
    package_managers="on"
    shell_path="off"
    shell_version="on"
    speed_type="bios_limit"
    speed_shorthand="on"
    cpu_brand="on"
    cpu_speed="on"
    cpu_cores="logical"
    cpu_temp="off"
    gpu_brand="on"
    gpu_type="all"
    refresh_rate="on"
    gtk_shorthand="off"
    gtk2="on"
    gtk3="on"
    public_ip_host="http://ident.me"
    public_ip_timeout=2
    disk_show=('/')
    disk_subtitle="dir"
    music_player="auto"
    song_format="%artist% - %album% - %title%"
    song_shorthand="off"
    mpc_args=()
    colors=(distro)
    bold="on"
    underline_enabled="on"
    underline_char="-"
    separator=":"
    block_range=(0 15)
    color_blocks="on"
    block_width=3
    block_height=1
    bar_char_elapsed="-"
    bar_char_total="="
    bar_border="on"
    bar_length=15
    bar_color_elapsed="distro"
    bar_color_total="distro"
    cpu_display="off"
    memory_display="off"
    battery_display="off"
    disk_display="off"
    image_backend="ascii"
    image_source="auto"
    ascii_distro="auto"
    ascii_colors=(distro)
    ascii_bold="on"
    image_loop="off"
    thumbnail_dir="${config.xdg.cacheHome}/thumbnails/neofetch"
    crop_mode="normal"
    crop_offset="center"
    image_size="auto"
    gap=3
    yoffset=0
    xoffset=0
    background_color=
    stdout="off"
  '';
}