{
  lib,
  inputs,
  withSystem,
  self,
  my-lib,
  ...
}:
let
  # 创建 home-manager 配置的函数
  # 参数:
  #   - system: 目标系统架构（如 "x86_64-linux"）
  #   - modules: home-manager 模块列表
  mkNixos =
    { system, modules }:
    inputs.nixpkgs.lib.nixosSystem (
      withSystem system (
        { pkgs, ... }:
        {
          inherit system pkgs modules;
          specialArgs = { inherit inputs; };
        }
      )
    );

  # 将子目录的配置转换为 home-manager 配置
  mapNixosConfigurations = lib.mapAttrs (
    n: v:
    mkNixos (v {
      inherit self inputs;
    })
  );
in
my-lib.importSubfolders ./.
|> mapNixosConfigurations
|> lib.setAttrByPath [
  "flake"
  "nixosConfigurations"
]
