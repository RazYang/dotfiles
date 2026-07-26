# dotfiles (Nix Flake)

个人 Nix Flake，主要用来管理NixOS、home-manager、nix-darwin配置，也包含packages/bundlers等flake输出支持。

## 主要内容
- 支持的系统架构：`x86_64-linux`、`aarch64-linux`、`aarch64-darwin`
- nixos配置：`playground`（NixOS，impermanence + home-manager + 示例服务）
- home-manager配置：`razyang`、`root`、`root@playground`（均为 x86_64-linux）、`yang`（aarch64-darwin）
- packages：`nixvim`、`nix-index-with-small-db`、`hm-switch`等
- formatter：treefmt

## 仓库结构
- `flake.nix`：声明基于 `nixos-unstable` 的 inputs，实际 flake-parts 入口为 `parts.nix`
- `modules`：参考[dendritic](https://github.com/mightyiam/dendritic)模式，每个文件都是一个flake module
- `packages/`：由 [flake-by-folder](https://github.com/RazYang/flake-by-folder) 自动导入各子目录的 `package.nix`
- `devshells/`：由 flake-by-folder 自动导入各子目录的 `devshell.nix`
- `overlays/`：由 flake-by-folder 自动导入各子目录的 `overlay.nix`
- `bundlers/`：由 flake-by-folder 自动导入各子目录的 `bundler.nix`

## 快速开始
1) 安装 Nix 并启用实验特性 `nix-command flakes`
2) 克隆仓库：`git clone <repo-url> && cd dotfiles`
3) 预览输出：`nix flake show`
4) NixOS：`nix run .#nixos-switch`
5) nix-darwin：`nix run .#darwin-switch`
6) 独立home-manager：`nix run .#hm-switch`
7) 构建包：`nix build .#nixvim`、`nix build .#nix-index-with-small-db`
8) 进入开发环境：`nix develop .#hello-custom`
9) 代码格式化：`nix fmt`
