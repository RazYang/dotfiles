# CLAUDE.md
供 AI 助手在本仓库内快速对齐上下文与交付约定。

## 项目速览
- Nix flake 管理 RazYang 的 NixOS、独立 Home Manager 与 macOS 环境，内置镜像加速。
- 支持 system：`x86_64-linux`、`aarch64-linux`、`aarch64-darwin`；主机/用户配置见 `README.md`。
- 自定义包位于 `packages/`，home/nixos/darwin 配置分别在对应目录。

## 角色信息
- 角色：仓库 AI 助手，辅助维护 Nix flake、Home Manager、NixOS 与自定义包。
- 语言：默认简体中文，输出简洁，路径/命令用反引号。
- 范畴：优先回答 flake/home/nixos/packages 相关问题，避免触碰无关文件。
- 风格：先结论后细节，必要时提供可直接运行的命令示例。

## Nix 相关知识

### 模块系统（evalModules）
- nixpkgs 的 `lib.evalModules` 是 NixOS、Home Manager、flake-parts 共用的模块求值器；模块形态 `{ imports; options; config; }`。
- 选项声明用 `mkOption { type; default; example; description; apply; }`；`options` 定义 schema，`config` 写具体值。
- 拆分配置：`imports` 接受模块/目录/函数，目录会加载 `default.nix`；会合并 attrset 与 list（非简单覆盖），可在顶层 `default.nix` 聚合子模块。
- 优先级：直接赋值与 `mkDefault` 均为优先级 1000；`mkForce` 为 50（数值越小优先级越高），适合先在基础模块给默认值，再在上层强制覆盖。
- 合并顺序：`mkBefore`/`mkAfter`（`mkOrder 500/1500`）控制 list/string 的拼接顺序，避免同优先级冲突；`mkMerge` 叠加、`mkIf` 条件启用。
- 传参：`evalModules { modules = [...]; specialArgs = {...}; }` 注入全局参数；模块内部 `_module.args` 可继续透传。
- 命名空间：flake-parts 顶层选项为 `flake.*`；Home Manager/NixOS 则暴露到 `config.*`，共享同一 evalModules 机制。

### 固定点（lib.fix）
- `lib.fix` 是惰性固定点组合子，用于构造自引用 attrset；调用形式 `self: { ... self ... }`，返回其固定点。
- 是 overlays、`lib.extend` 等机制的基础；相比 `rec`，`fix` 以函数求解自引用并保持惰性。
- 参考：https://akavel.github.io/post/nix-fixpoint/。

### 管道运算符（`|>`，RFC 0148）
- RFC 0148 提议在 Nix 语言内置 `|>`，语义为反转实参顺序的函数应用：`f a` 等价于 `a |> f`；左结合、弱于函数应用。
- 现状：可用 `lib.pipe a [f g h]` 作为等价替代，`|>` 将提升可读性与可发现性，未来可能成为内建运算符并提升错误溯源体验。
- 与 `lib.pipe` 的关系：`|>` 可视为展开版 `lib.pipe`，减少括号与列表包装；当 `|>` 可用时，可逐步从 `lib.pipe` 迁移。
- **当调用函数嵌套>=3时，优先使用`|>`运算符增加代码可读性**
- 参考：https://raw.githubusercontent.com/NixOS/rfcs/1026104d8fb8db751b5941cea45ba97f8fbfabb7/rfcs/0148-pipe-operator.md

### 包作用域与 callPackage/makeScope
- `callPackage` 会按形参与包集交集自动注入依赖，便于内部包间复用，避免手写长形参列表。
- `lib.makeScope pkgs.newScope myPackages` 可创建独立包作用域，让内部包可互相依赖又不污染/覆盖上游 `nixpkgs`，解决命名冲突与多版本混用风险（详见 https://andreas.rammhold.de/posts/nix-package-scopes/）。
- 建议将内部包集与上游 `nixpkgs` 区分导出，必要时用自定义 `callPackage = pkgs.lib.callPackageWith (nixpkgs // self);` 保持两者并行可见。

### 包 override 与 infuse
- nixpkgs 中的固定点 override 机制可通过 nixpkgs的`config.packageOverrides`参数 或 针对某一个具体的包`pkg.override/overrideAttrs` 叠加（参考 https://nixos.org/guides/nix-pills/17-nixpkgs-overriding-packages.html）。
- `infuse.nix` 提供更简洁的深度 override 语法糖，泛化 `lib.pipe` 与 `recursiveUpdate`，支持对 attrset/list/function 统一叠加（仓库：https://codeberg.org/amjoseph/infuse.nix）。
- **本项目优先使用 infuse 的语法糖执行包 override**，可减少嵌套 override/overrideAttrs 与重复 attrs 合并。


## 常用命令
- 预览 flake：`nix flake show`
- 应用 Home Manager：`home-manager switch --flake .#<attr>`
- NixOS 切换：`sudo nixos-rebuild switch --flake .#playground`
- 构建包：`nix build .#hello-custom`、`nix build .#nixvim`、`nix build .#hm`
- 快速切换 HM：`nix run .#hm-switch -- <attr>`（默认 `$HM_SWITCH_ATTR` 或 `$USER`）
- 进入 dev shell：`nix develop -f dev-shells/ctf`（或 `-f dev-shells/test`）
- 格式化：项目整体格式化`nix fmt`，单文件格式化/语法检查`nixfmt <file>`

## 开发约定
- Nix 代码使用 treefmt（nixfmt-rfc-style）；改动后运行 `nix fmt`。
- **改动文件后，需要执行nixfmt检测语法错误**
- 保持 ASCII，注释精炼；新增文件按现有目录约定放置。
- 避免改动无关文件，不要回滚用户已有变更。
- 回答/文档保持简洁中文，路径使用反引号标注。
