{ pkgs, ... }:

let
  discord = (pkgs.discord.override {
    nss = pkgs.nss_latest;
  }).overrideAttrs (prev: {
    nativeBuildInputs = prev.nativeBuildInputs ++ [pkgs.makeWrapper];
    libPath = prev.libPath + ":${pkgs.libglvnd}/lib";
    postFixup = ''
      wrapProgram $out/opt/Discord/Discord --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    '';
  });
in {
  home.packages = [ discord ];
}
