# dotfiles (Nix Flake)

个人 Nix Flake，主要用来管理NixOS、home-manager、nix-darwin配置，也包含packages/bundlers等flake输出支持。

## 主要内容
- 支持的系统架构：`x86_64-linux`、`aarch64-linux`、`aarch64-darwin`
- nixos配置：`playground`（NixOS，impermanence + home-manager + 示例服务）
- home-manager配置：`razyang`、`root`、`root@playground`（均为 x86_64-linux）、`yang`（aarch64-darwin）
- packages：`hello-custom`、`nixvim`、`hm-switch`等
- formatter：treefmt
- 交叉编译支持：nix build .#pkgsCross.aarch64-multiplatform.hello-custom

## 仓库结构
- `flake.nix`：目前该文件的作用约等于go.mod，真正的entrypint为part.nix，这么做是为[rfc_0193](https://github.com/NixOS/rfcs/pull/193)以及[rfc_0194](https://github.com/NixOS/rfcs/pull/194)做准备
- `modules`：参考[dendritic](https://github.com/mightyiam/dendritic)模式，每个文件都是一个flake module
- `services/`：[process-compose-flake](https://github.com/Platonic-Systems/process-compose-flake)服务
- `packages/`：自定义包，按包名分目录，自动导入每个目录下的`package.nix`文件，具有交叉编译支持
- `devshells/`：[numtide/devshell](https://github.com/numtide/devshell)develop环境定义独立，自动导入每个子目录下的`devshell.nix`
- `bundlers/`：应用打包器集合，自动导入每个子目录下的`bundler.nix`

## 快速开始
1) 安装 Nix 并启用一些额外的实验特性`nix-command flakes pipe-operators`
2) 克隆仓库：`git clone <repo-url> && cd dotfiles`
3) 预览输出：`nix flake show`
4) NixOS：`nix run .#nixos-switch`
5) nix-darwin：`nix run .#darwin-switch`
6) 独立home-manager：`nix run .#hm-switch`
5) 构建包：`nix build .#hello-custom`、`nix run .#pkgsCross.aarch64-multiplatform.hello-custom`
7) 进入开发环境：`nix develop .#hello-custom`
8) 代码格式化：`nix fmt`