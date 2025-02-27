#!/run/current-system/sw/bin/zsh
set -e

# export NIX_PATH="/users/b/nixos-config/configuration.nix"

pushd ~/nixos-config

# show changes
git --no-pager diff -U0 '*.nix'

# my downloads folder is in ram so I'm starting to throw my garbage there
# sudo nixos-rebuild switch &>/users/b/Downloads/nixos-switch.log || (cat /users/b/Downloads/nixos-switch.log | grep --color error && exit 1)
sudo nixos-rebuild switch


# Get current generation metadata
git add configuration.nix
current=$(nixos-rebuild list-generations | grep current)
git commit -am "$current"

popd
echo "done"
# notes for first time setup
# sudo mv /etc/nixos/configuration.nix ~/nixos-config
#
# symlink configuration.nix back to /etc/nixos
#  or export NIX_PATH="nixos-config=/path/to/configuration.nix"
