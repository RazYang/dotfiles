{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    #inputs.self.packages.${pkgs.system}.nixvim
    nixfmt-rfc-style
    ncdu
  ];
}
