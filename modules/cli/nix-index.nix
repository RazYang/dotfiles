{ ... }: {
  flake.modules.home.base = { self', ... }: {
    programs.nix-index = {
      enable = true;
      package = self'.packages.nix-index-with-small-db;
    };
  };
}
