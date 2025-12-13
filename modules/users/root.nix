{
  config,
  inputs,
  withSystem,
  ...
}:
{
  flake.modules.users.root = {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.home.base
      (
        { pkgs, ... }:
        {
          home = {
            username = "root";
            homeDirectory = "/root";
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
