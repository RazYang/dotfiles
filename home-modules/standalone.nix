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
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
  ];
  programs.nix-index-database.comma.enable = true;
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      extra-substituters = lib.mkForce [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      extra-experimental-features = "nix-command flakes";
    };
  };
  home = {
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
  };
  programs.home-manager.enable = true;
}
