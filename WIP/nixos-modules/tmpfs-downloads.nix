{ config, lib, pkgs, user }:

with lib;

let
  cfg = config.services.tmpfsDownloads;
in {
  options.services.tmpfsDownloads = {
    enable = mkEnableOption "tmpfs Downloads folder";
    username = mkOption {
      type = types.str;
      description = "Username for the tmpfs Downloads folder";
    };
    size = mkOption {
      type = types.str;
      default = "3G";
      description = "Size of the tmpfs Downloads folder";
    };
  };

  config = mkIf cfg.enable {
    fileSystems."/home/${cfg.username}/Downloads" = {
      fsType = "tmpfs";
      options = [
        "size=${cfg.size}"
        "mode=1777"
      ];
    };
  };
}