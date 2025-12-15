{
  pkgs,
  inputs,
  users,
  ...
}:
{
  users.users.yang.home = "/Users/yang";
  home-manager.extraSpecialArgs.inputs = inputs;
  home-manager.users.yang = {
    imports = users.yang.modules;
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      trusted-users = [
        "yang"
        "root"
      ];
    };
    optimise.automatic = true;
  };

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [ ];
  system.stateVersion = 6;
}
