# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdd";
  boot.loader.grub.useOSProber = true;

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
      "size=12G"
      "mode=777"
    ];
  };

  #turtle-wow
  fileSystems."/home/b/Games/turtle-wow/WDB" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=4G"
      "mode=777"
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
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # search.nixos.org/options to see what can be configured
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
    };

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nix-ld # LD Fix
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter
    alacritty
    vesktop # discord clone
    keepassxc
    libappimage # functionality for appimages
    polychromatic # razer lights configuration
    rustup
    zed-editor
    zsh
    gamescope
    openrazer-daemon # keyboard lights
  ];

  # Terminal setup
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      switch = "sudo nixos-rebuild switch"; # todo: larger script
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

  ### STEAM
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
