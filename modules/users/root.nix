{
  config,
  inputs,
  withSystem,
  ...
}:
let
  username = "root";
in
{
  flake.modules.users."${username}" = {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.home.base
      (
        { pkgs, ... }:
        {
          home = {
            inherit username;
            homeDirectory = "/${username}";
            stateVersion = "24.05";
            packages = with pkgs; [
              nixfmt-rfc-style
              gitMinimal
              gdu
              nix-tree
              stdman
              broot
              urlencode
            ];
          };
        }
      )
    ];
  };
}
