rec {
  profile = user: p: v: {
    home-manager.users.${user} = profiles.${p} // {
      home = {
        stateVersion = v;
        username = user;
      };
    };
  };

  profiles = {
    full.imports = [
      ./development
      ./development/c.nix
      ./development/elixir.nix
      ./development/java.nix
      ./development/javascript.nix
      ./development/kotlin.nix
      ./development/haskell.nix
      ./development/lean.nix
      ./development/nix.nix
      ./development/ocaml.nix
      ./development/rust.nix
      ./development/scala.nix
      ./development/zig.nix
    ];
    minimal = { };
  };
}
