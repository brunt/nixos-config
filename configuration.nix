# setup steps:
# cd ~
# git clone git@github.com:brunt/nixos-config.git
# sudo rm /etc/nixos/configuration.nix
# sudo ln -s /home/b/nixos-config/configuration.nix /etc/nixos/configuration.nix
# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
# sudo nix-channel --update
# copy turtle wow folder to ~/Games
# adjust boot loader section as necessary
# sudo nixos-rebuild switch

# notes:
# librewolf alternative browser
# https://www.reddit.com/r/NixOS/comments/1j0sm8q/thanks_to_nixos_and_homemanager_this_diff_was/

{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports =
    [
      <home-manager/nixos>
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "bishop"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fileSystems."/home/b/Downloads" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=100G"
      "mode=777"
    ];
  };

  fileSystems."/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=100G"
      "mode=777"
    ];
  };


#   fileSystems."/home/b/Games/turtle-wow/WDB" = {
#     device = "none";
#     fsType = "tmpfs";
#     options = [
#       "size=4G"
#       "mode=777"
#     ];
#   };

  #second hard drive
  fileSystems."/home/b/Games" = {
    device = "/dev/disk/by-uuid/da58d3c4-c102-45cd-aa72-381363234d5f";
    fsType = "ext4";
    options = [
      "defaults"
      "user"
      "rw"
      "noatime"
    ];
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.openrazer.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Home Manager configuration
  home-manager.users.b =
    { pkgs, ... }:
    {
      home.stateVersion = "24.11";

      programs.git = {
        enable = true;
        lfs.enable = true;
        extraConfig = {
          push = {
            autoSetupRemote = true;
          };
        };
        userName = "Bryant Deters";
        userEmail = "bryantdeters@gmail.com";
      };
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.b = {
    isNormalUser = true;
    description = "bryant";
    extraGroups = [
      "networkmanager"
      "wheel"
      "openrazer"
    ];
    packages = with pkgs; [
      kdePackages.kdeconnect-kde # phone integration
      kdePackages.kdf # storage info
      kdePackages.kcalc
      kdePackages.ktorrent
      (writeShellScriptBin "rebuild" ''
        set -e
        pushd ~/nixos-config
        git --no-pager diff -U0 '*.nix'
        sudo nixos-rebuild switch
        git add configuration.nix
        current=$(nixos-rebuild list-generations | grep current)
        git commit -am "$current"
        popd
        echo "done"
      '')
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  programs.firefox = {
    enable = true;
    preferences = {
      #about:config stuff
      "browser.cache.disk_cache_ssl" = false;
      "browser.cache.disk.enable" = false;
      "browser.cache.memory.enable" = true;
      "extensions.pocket.enabled" = false;
    };

    # Check about:policies#documentation for options.
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };

        # VivalidFox:
        "@vivaldi-fox" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4023673/vivaldifox-3.6.xpi";
          installation_mode = "force_installed";
        };
        # Facebook Container:
        "@contain-facebook" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4141092/facebook_container-2.3.11.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nix-ld # LD Fix
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter
    alacritty # terminal emulator
    vesktop # discord clone
    vlc
    keepassxc # password manager
#     libappimage # functionality for appimages
    polychromatic # razer lights configuration
    rustup # rust lang
#     unstable.zed-editor # this is erroring on build
    gamescope
    openrazer-daemon # keyboard lights
    obsidian #notes
    obs-studio
  ];

  # Terminal setup
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      rollback = "sudo nixos-rebuild --rollback";
    };
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

  # LD Fix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      # extraEnv = {
      #   SDL_VIDEODRIVER = "windows";
      #   ENABLE_VKBASALT = 0;
      #   PROTON_HIDE_NVIDIA_GPU = 0;
      #   PROTON_ENABLE_NVAPI = 1;
      #   PROTON_ENABLE_NGX_UPDATER = 1;
      #   PROTON_USE_D9VK = 1;
      #   PROTON_USE_VKD3D = 1;
      #   DXVK_ASYNC = 1;
      #   __GL_VRR_ALLOWED = 1;
      #   PROTON_NO_ESYNC = 1;
      # };
    };
  };
  programs.gamemode.enable = true;
  # open ports for steam stream and some games
  networking.firewall.allowedTCPPorts =
    with pkgs.lib;
    [
      27036
      27037
    ]
    ++ (range 27015 27030);
  networking.firewall.allowedUDPPorts =
    with pkgs.lib;
    [
      4380
      27036
    ]
    ++ (range 27000 27031);
  networking.firewall.allowPing = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    # ports for KDE Connect
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  # Garbage collection of nix store
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  # De-duplicate nix store
  nix.settings.auto-optimise-store = true;

  # Auto updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
