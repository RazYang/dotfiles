{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.self.homeModules.common
    inputs.nix-index-database.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nix-index-database.comma.enable = true;
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      extra-experimental-features = "nix-command flakes";
      extra-substituters = [
        #"https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  home = {
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
  };
  programs.home-manager.enable = true;
}
