{ username, inputs }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.homeModules.standalone
    ./packages.nix
    ({
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };
    })
  ];
}
