{
  config,
  inputs,
  withSystem,
  ...
}:
let
  username = "razyang";
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
            homeDirectory = "/home/${username}";
            stateVersion = "24.05";
            packages = with pkgs; [
              nixfmt-rfc-style
              gdu
              nix-tree
              stdman
              urlencode
            ];
          };
          programs = {
            direnv = {
              enable = true;
              nix-direnv.enable = true;
              enableZshIntegration = true;
            };
          };
        }
      )
    ];
  };
}
