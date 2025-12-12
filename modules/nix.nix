{ config, lib, ... }:
let
  cfg = config.flake.modules.nix;
in
{
  options = {
    flake.modules.nix.settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        extra-substituters = [
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://mirrors.ustc.edu.cn/nix-channels/store"
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operators"
        ];
      };
    };
  };
}
