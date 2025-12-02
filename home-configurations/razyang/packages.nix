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
    #    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nixvim
  ];
}
