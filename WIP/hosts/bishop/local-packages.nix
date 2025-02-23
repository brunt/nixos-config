{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nix-ld # LD Fix
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter
    (writeShellScriptBin "nixos-rebuild.sh" ''
        // Script without shebang

            '')

  ];

  # LD Fix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
}