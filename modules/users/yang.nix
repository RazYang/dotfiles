{
  config,
  inputs,
  withSystem,
  ...
}:
{
  flake.modules.users.yang = {
    system = "aarch64-darwin";
    modules = [
      config.flake.modules.home.base
      (
        { pkgs, ... }:
        {
          home = {
            username = "yang";
            homeDirectory = "/Users/yang";
            stateVersion = "24.05";
            packages = with pkgs; [
              nixfmt-rfc-style
              gdu
              nix-tree
            ];
          };
          programs.home-manager.enable = true;
        }
      )
    ];
  };
}
