{
  config,
  inputs,
  withSystem,
  ...
}:
let
  username = "yang";
in
{
  flake.modules.users."${username}" = {
    system = "aarch64-darwin";
    modules = [
      config.flake.modules.home.base
      (
        { pkgs, ... }:
        {
          home = {
            inherit username;
            homeDirectory = "/Users/${username}";
            stateVersion = "24.05";
            packages = with pkgs; [
              nixfmt-rfc-style
              gdu
              nix-tree
            ];
          };
        }
      )
    ];
  };
}
