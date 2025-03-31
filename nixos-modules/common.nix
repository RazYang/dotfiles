{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = rec {
      auto-optimise-store = true;
      substituters = [
        #"https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      trusted-substituters = substituters ++ [ "https://cache.nixos.org/" ];
    };
    extraOptions = ''
      extra-experimental-features = nix-command flakes
    '';
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  time.timeZone = "Asia/Shanghai";
  networking.firewall.enable = false;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
}
