# Dotfiles

Razyang's dotfiles managed by nix and home-manager.

# Show what's supported

```bash
nix flake show "github:razyang/dotfiles"
```

or using `nix repl`, `:lf "github:razyang/dotfiles"` function. or using git to
download this flake
`nix flake show "git+https://github.com/Zzorz/dotfiles?submodules=1&shallow=1"`

# Installation

## for non nixos host

### Install nix first

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### Add experimental features setting to /etc/nix/nix.conf

```bash
echo 'extra-experimental-features = nix-command flakes' >> /etc/nix/nix.conf
```

### using home-manager, switch to my config

```bash
nix run 'github:nix-community/home-manager' -- switch --flake 'github:razyang/dotfiles'
```

OR

```bash
nix run 'git+https://github.com/nix-community/home-manager?submodules=1&shallow=1' -- switch --flake 'git+https://github.com/Zzorz/dotfiles?submodules=1&shallow=1'
```

suppurted usernames are `razyang`,`test` and `root`.

## for nixos

```bash
nixos-rebuild switch --flake "github:razyang/dotfiles"
```

OR

```bash
nixos-rebuild switch --flake 'git+https://github.com/Zzorz/dotfiles?submodules=1&shallow=1'
```

suppurted hostnames are `playground`, `adguardhome` and `fileserver`

### Just neovim alone

```bash
nix profile install 'github:razyang/dotfiles#nixvim'
```

Without install

```bash
nix run 'github:razyang/dotfiles#nixvim'
```

# pack any executable in nixpkgs and run it anywhre

here's a nix bundler in this project which base on bwrap and erofs-utils, it's
simple but very useful:

```bash
$ nix bundle --bundler 'github:Zzorz/dotfiles#bwrap' 'nixpkgs#nginx'
$ nginx-1.26.2.tar.gz
$ ./nginx-1.26.2 -v
nginx version: nginx/1.26.2
```

# Thanks

A huge thank you to [@accelbread](https://github.com/accelbread) for his
outstanding work on [flakelight](https://github.com/nix-community/flakelight),
which has greatly simplified the structure of this project, making it much
neater, cleaner, and easier to understand.
