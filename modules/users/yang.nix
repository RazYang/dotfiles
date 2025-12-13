{
  config,
  inputs,
  withSystem,
  ...
}:
{
  config.flake.homeConfigurations.yang = withSystem "aarch64-darwin" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        config.flake.modules.home.base
        ({
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
        })
      ];
    }
  );
}
