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
      ({ pkgs, ... }: {
        home = {
          inherit username;
          homeDirectory = "/${username}";
          stateVersion = "24.05";
          packages = with pkgs; [
            ast-grep
            fd
            jq
            nixfmt
            gitMinimal
            gdu
            nix-tree
            ripgrep
            stdman
            broot
            urlencode
            yq-go
          ];
        };
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          silent = true;
        };
      })
    ];
  };
}
