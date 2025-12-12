{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./zsh.nix
    inputs.nix-index-database.homeModules.nix-index
  ];
  nix = {
    keepOldNixPath = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = inputs.nixpkgs;
      };
      home-manager = {
        from = {
          id = "home-manager";
          type = "indirect";
        };
        flake = inputs.home-manager;
      };
    };
  };
  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  programs = {
    git.settings.user = {
      name = "RazYang";
      email = "xzzorz@gmail.com";
    };
    home-manager.enable = true;
    tmux = {
      enable = true;
      escapeTime = 0;
      baseIndex = 1;
      historyLimit = 5000;
      keyMode = "vi";
      prefix = "C-q";
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        gruvbox
        extrakto
      ];
      extraConfig = ''
        unbind '"'
        unbind %
        bind h split-window -h
        bind v split-window -v
        bind-key t display-popup -w "60%" -h "80%"  -E "taskwarrior-tui"
        bind -n M-a select-pane -L
        bind -n M-d select-pane -R
        bind -n M-w select-pane -U
        bind -n M-s select-pane -D
        set-option -g status-position bottom
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    command-not-found.enable = false;

    nix-index-database.comma.enable = true;
    nix-index = {
      enable = true;
      package =
        inputs.nix-index-database.packages."${pkgs.stdenv.hostPlatform.system}".nix-index-with-small-db;
    };

    ripgrep.enable = true;
    broot.enable = true;
    bottom.enable = true;

    lsd = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
