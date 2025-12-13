{
  config,
  inputs,
  withSystem,
  ...
}:
{
  config.flake.homeConfigurations.razyang = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        config.flake.modules.home.base
        ({
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
        })
      ];
    }
  );
}
