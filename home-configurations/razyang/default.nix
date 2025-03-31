{
  inputs,
  pkgs,
  ...
}:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    inherit inputs;
  };
  modules = [
    inputs.self.homeModules.standalone
    ./packages.nix
    {
      home = {
        username = "razyang";
        homeDirectory = "/home/razyang";
        stateVersion = "24.05";
      };
    }
  ];
}
