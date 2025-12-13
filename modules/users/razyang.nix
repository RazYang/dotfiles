{
  config,
  inputs,
  withSystem,
  ...
}:
{
  flake.modules.users.razyang = {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.home.base
      (
        { pkgs, ... }:
        {
          home = {
            username = "razyang";
            homeDirectory = "/home/razyang";
            stateVersion = "24.05";
            packages = with pkgs; [
              nixfmt-rfc-style
              gdu
              nix-tree
              stdman
              urlencode
            ];
          };
          programs.home-manager.enable = true;
        }
      )
    ];
  };
}
