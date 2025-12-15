{
  pkgs,
  inputs,
  users,
  ...
}:
{
  home-manager.extraSpecialArgs.inputs = inputs;
  home-manager.users.yang = {
    imports = users.yang.modules;
  };

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [ ];
  system.stateVersion = "24.05";
}
