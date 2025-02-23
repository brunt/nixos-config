{ pkgs, stateVersion, hostname, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos-modules
  ];

    services.tmpfsDownloads = {
      enable = true;
      username = user;
      size = "3G";  # Optional: Override the default size
    };

  environment.systemPackages = [ pkgs.home-manager ];

  networking.hostName = hostname;

  system.stateVersion = stateVersion;
}
