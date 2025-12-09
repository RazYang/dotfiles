{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    #inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nixvim
    nixfmt-rfc-style
    gdu
    nix-tree
  ];
}
