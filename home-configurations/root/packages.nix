{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    vim
    gdu
    git
    htop
    file
    binutils
    nix-tree
    codex
    zcf
    nixfmt-rfc-style
  ];
}
