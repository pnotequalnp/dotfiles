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
      ./development/nix.nix
      ./development/ocaml.nix
      ./development/rust.nix
      ./development/zig.nix
    ];
    minimal = { };
  };
}
