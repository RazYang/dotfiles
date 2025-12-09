{ username, self }:
{
  system = "x86_64-linux";
  modules = [
    self.homeModules.standalone
    ./packages.nix
    ({
      home = {
        inherit username;
        homeDirectory = "/${username}";
        stateVersion = "24.05";
      };
    })
  ];
}
