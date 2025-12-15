{ pkgs, self', ... }:
{
  devshell.packages = with pkgs; [
    wget
    self'.packages.hello-custom
  ];
}
