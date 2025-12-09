username: {
  system = "aarch64-darwin";
  modules = [
    #inputs'.self.homeModules.standalone
    #./packages.nix
    ({
      home = {
        inherit username;
        homeDirectory = "/Users/${username}";
        stateVersion = "24.05";
      };
    })
  ];
}
