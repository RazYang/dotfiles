{
  pkgs,
  inputs,
  users,
  ...
}:
{
  users.users.yang.home = "/Users/yang";
  home-manager.users.yang = {
    imports = users.yang.modules;
  };
  nix.settings.trusted-users = [
    "root"
    "razyang"
  ];

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [ ];
  system.stateVersion = 6;
}
