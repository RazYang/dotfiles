{ ... }: {
  flake.modules.home.base = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      escapeTime = 0;
      baseIndex = 1;
      historyLimit = 5000;
      keyMode = "vi";
      prefix = "C-q";
      terminal = "tmux-256color";
      plugins = with pkgs.tmuxPlugins; [ gruvbox ];
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
  };
}
