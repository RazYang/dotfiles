{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../common
  ];
  nix = lib.mkDefault {
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
