{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    stdman
    taskwarrior-tui
    taskwarrior3
    nixfmt-rfc-style
    nix-tree
    urlencode
  ];
}
