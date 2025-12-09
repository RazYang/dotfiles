{
  lib,
  inputs,
  withSystem,
  self,
  ...
}:
let
  # 创建 home-manager 配置的函数
  # 参数:
  #   - system: 目标系统架构（如 "x86_64-linux"）
  #   - modules: home-manager 模块列表
  mkHome =
    { system, modules }:
    inputs.home-manager.lib.homeManagerConfiguration (
      withSystem system (
        { pkgs, ... }:
        {
          inherit pkgs modules;
          extraSpecialArgs.inputs = inputs;
        }
      )
    );

  # 从字符串中提取用户名
  # 例如: "user@host" -> "user"
  # 通过 "@" 符号分割字符串并取第一部分
  extractUsername =
    str:
    lib.pipe str [
      (lib.splitStringBy (prev: curr: builtins.elem curr [ "@" ]) false)
      (l: builtins.elemAt l 0)
    ];

  # 将子目录的配置转换为 home-manager 配置
  mapHomeConfigurations = lib.mapAttrs (
    n: v:
    mkHome (v {
      inherit self;
      username = (extractUsername n);
    })
  );
in
self.lib.importSubfolders ./.
|> mapHomeConfigurations
|> lib.setAttrByPath [
  "flake"
  "homeConfigurations"
]
