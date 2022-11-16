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
      ./development/haskell.nix
      ./development/rust.nix
    ];
    minimal = { };
  };
}
