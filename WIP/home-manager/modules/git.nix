{
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      push = { autoSetupRemote = true; };
    };
    userName = "brunt";
    userEmail = "bryantdeters@gmail.com";
  };
}