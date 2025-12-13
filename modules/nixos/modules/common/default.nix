{ pkgs, ... }:
{

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  time.timeZone = "Asia/Shanghai";
  networking.firewall.enable = false;
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
}
