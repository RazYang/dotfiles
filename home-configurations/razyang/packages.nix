{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    radare2
    stdman
    taskwarrior-tui
    taskwarrior3
    sbomnix
    nixfmt-rfc-style
    nix-tree
    inputs.self.packages.${pkgs.system}.nixvim
  ];
}
