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
    full = { imports = [ ]; };
    minimal = { };
  };
}
