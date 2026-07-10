# dotfiles

Nix-managed macOS dotfiles using nix-darwin, nix-homebrew, and home-manager.

## Installation

```sh
# 1. Install Nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# 2. Open a new terminal and confirm Nix is available
nix --version

# 3. Clone dotfiles
nix-shell -p git --run "git clone https://github.com/shoyoshikane/dotfiles ~/dotfiles"

# 4. Back up existing system shell configs if nix-darwin reports conflicts
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin

# 5. Apply the host profile for the first time
host="<host>"
sudo -H /nix/var/nix/profiles/default/bin/nix run \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake "$HOME/dotfiles/.config/nix#$host"
```

After the initial setup, use the flake apps:

```sh
darwin-switch
darwin-build
darwin-check
darwin-update
```

## Layout

- `.config/nix/flake.nix`: entrypoint
- `.config/nix/hosts/gift/default.nix`: host profile
- `.config/nix/modules/host-spec.nix`: shared host metadata options
- `.config/nix/darwin/aerospace.nix`: AeroSpace service
- `.config/nix/darwin/homebrew.nix`: Homebrew formulae, casks, and taps
- `.config/nix/home-manager/dotfiles.nix`: symlinks for dotfiles

## Adding A Host

Create a new host profile from an existing one:

```sh
host="<host>"
cp -R "$HOME/dotfiles/.config/nix/hosts/gift" \
  "$HOME/dotfiles/.config/nix/hosts/$host"
```

Then update `.config/nix/hosts/<host>/default.nix`:

```nix
{
  hostSpec = {
    username = "<username>";
    hostName = "<host>";
  };

  system.stateVersion = 5;
}
```

Finally, add the host to `.config/nix/flake.nix`:

```nix
hosts = {
  gift = ./hosts/gift;
  <host> = ./hosts/<host>;
};
```

## Notes

- Existing dotfiles are backed up with the `.backup` suffix when home-manager first takes over.
- Existing Homebrew installations are migrated by `nix-homebrew`; undeclared packages are not removed because Homebrew cleanup is disabled.
