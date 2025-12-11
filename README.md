# dotfiles (Nix Flake)

个人 Nix Flake，用来管理 RazYang 的 NixOS、独立 Home Manager 与 macOS 环境，内置镜像加速、自定义包和示例服务配置。

## 支持矩阵
- 系统架构：`x86_64-linux`、`aarch64-linux`、`aarch64-darwin`
- 主机配置：`playground`（NixOS，impermanence + home-manager + 示例服务）
- Home 配置：`razyang`、`root`、`root@playground`（均为 x86_64-linux）、`yang`（aarch64-darwin）
- 导出包：`hello-custom`、`nixvim`、`hm`（home-manager 可执行）
- 格式化：treefmt（nixfmt-rfc-style、jsonfmt）

## 仓库结构
- `flake.nix`：输入源、镜像、flake-parts 入口
- `systems.nix`：支持的 system 列表
- `home/`：homeModules 与 homeConfigurations（zsh/tmux/nix-index 等基础模块）
- `nixos/`：nixosModules 与 nixosConfigurations（当前包含 playground 主机）
- `darwin/`：占位目录，后续扩展 nix-darwin
- `packages/`：自定义包，按包名分目录（每个目录 `default.nix` 自动被 flake 导入）
- `flake-modules/`：flake-parts 模块（`top-level.nix` 为入口，使用 `importSubfolders` 自动加载子模块，如 `treefmt/`）
- `dev-shells/`：独立 mkShell，按目录自动导出（`importSubfolders`）
- `bundlers/`：应用打包器集合，按目录自动导出（`importSubfolders`），如 `bwrap/`、`DSBundler/`

## 快速开始
1) 安装 Nix 并启用 flakes（nix.conf 中开启 `nix-command flakes pipe-operators`）。
2) 克隆仓库：`git clone <repo-url> && cd dotfiles`
3) 预览输出：`nix flake show`
4) Home Manager：
   - 桌面：`home-manager switch --flake .#razyang`
   - playground root：`home-manager switch --flake .#root@playground`
   - macOS：`home-manager switch --flake .#yang`
5) NixOS 主机：`sudo nixos-rebuild switch --flake .#playground`
6) 构建包：`nix build .#hello-custom`、`nix build .#nixvim`、`nix build .#hm`
7) 快捷切换 HM：`nix run .#hm-switch -- <attr>`（默认 `$HM_SWITCH_ATTR` 或 `$USER`）
8) 进入开发环境：`nix develop -f dev-shells/ctf`（或 `-f dev-shells/test`，目前未纳入 flake 输出）
9) 代码格式化：`nix fmt`

## 额外说明
- 默认使用中科大/清华/交大镜像及 nix-community cachix，加快拉取速度。
- Home 模块内置 zsh + tmux + nix-index/nix-index-database、Atuin、fzf、zoxide 等常用工具。
- NixOS `playground` 示例启用了 impermanence、dae、samba、nginx/ACME（按需开启）、postgresql 等占位服务，可按需裁剪。
- flake 内部通过 `importSubfolders` + 自定义 `callPackage` 作用域自动收集 `packages/` 子目录下的包（带 inputs/my-lib 透传），新增包只需放到同名目录并提供 `default.nix`。
- devshell/bundler 也同样通过 `importSubfolders` 自动导出：新增开发壳或打包器时放入对应目录（含 `default.nix`），无需额外注册。

