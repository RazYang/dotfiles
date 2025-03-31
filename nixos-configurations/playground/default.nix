{ inputs, pkgsWithSystem, ... }:
inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  pkgs = pkgsWithSystem system;
  modules = with inputs; [
    self.nixosModules.common
    home-manager.nixosModules.home-manager
    impermanence.nixosModules.impermanence
    ./configuration.nix
    #./containers
    ./hardware-configuration.nix
  ];
}
