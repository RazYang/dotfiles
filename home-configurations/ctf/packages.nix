{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gdu
    htop
    bottom
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nixvim
  ];
}
