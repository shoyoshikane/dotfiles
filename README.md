# dotfiles

Personal macOS dotfiles managed with nix-darwin, nix-homebrew, and home-manager.

## Setup

Install Nix first if it is not already installed:

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

Open a new terminal, then confirm that `nix` is available:

```sh
nix --version
```

If this repository is located at `$HOME/dotfiles`, apply the `gift` profile for the first time:

```sh
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin

sudo -H /nix/var/nix/profiles/default/bin/nix run \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake "$HOME/dotfiles/.config/nix#gift"
```

After the initial setup, apply changes with:

```sh
sudo darwin-rebuild switch --flake "$HOME/dotfiles/.config/nix#gift"
```

## Layout

- `.config/nix/flake.nix`: entrypoint
- `.config/nix/hosts/gift/default.nix`: host profile
- `.config/nix/darwin/homebrew.nix`: Homebrew formulae, casks, and taps
- `.config/nix/home-manager/dotfiles.nix`: symlinks for dotfiles

## Notes

- Existing dotfiles are backed up with the `.backup` suffix when home-manager first takes over.
- Existing Homebrew installations are migrated by `nix-homebrew`; undeclared packages are not removed because Homebrew cleanup is disabled.
