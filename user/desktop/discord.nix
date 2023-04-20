{ pkgs, ... }:

let
  discord = (pkgs.discord-canary.override {
    nss = pkgs.nss_latest;
  }).overrideAttrs (prev: {
    nativeBuildInputs = prev.nativeBuildInputs ++ [pkgs.makeWrapper];
    libPath = prev.libPath + ":${pkgs.libglvnd}/lib";
    postFixup = ''
      wrapProgram $out/opt/DiscordCanary/DiscordCanary --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    '';
  });
in {
  home.packages = [ discord ];
}
