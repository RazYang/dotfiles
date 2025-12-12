{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    vim
    gdu
    gitMinimal
    htop
    file
    binutils
    nix-tree
  ];
}
