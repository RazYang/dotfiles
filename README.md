# dotfiles (Nix Flake)

个人 Nix Flake，主要用来管理NixOS、home-manager、nix-darwin配置，也包含packages/bundlers等flake输出支持。

## 主要内容
- 支持的系统架构：`x86_64-linux`、`aarch64-linux`、`aarch64-darwin`
- nixos配置：`playground`（NixOS，impermanence + home-manager + 示例服务）
- home-manager配置：`razyang`、`root`、`root@playground`（均为 x86_64-linux）、`yang`（aarch64-darwin）
- packages：`hello-custom`、`nixvim`、`hm-switch`等
- formatter：treefmt

## 仓库结构
- `flake.nix`：输入源、镜像、flake-parts 入口
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
4) NixOS 主机：`sudo nixos-rebuild switch --flake .#playground`
5) 构建包：`nix build .#hello-custom`、`nix build .#nixvim`
6) 快捷切换 HM：`nix run .#hm-switch`
7) 进入开发环境：`nix develop .#ctf`
8) 代码格式化：`nix fmt`