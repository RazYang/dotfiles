{ pkgs, ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      history_filter = [
        "^cd"
        "^ls"
        "^svn"
        "^z "
        "^stat "
        "^rm "
        "^pwd"
        "^mv "
        "^touch "
        "^ps "
        "^vim "
        "^du "
        "^gdu "
        "^man "
        "^ncdu "
        "^file "
        "^tree "
        "^cloc "
      ];
      #daemon.enabled = true;
    };

  };
  #programs.starship = {
  #  enable = true;
  #  enableTransience = true;
  #};
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false,
        table: {
          mode: markdown,
          index_mode: auto,
        },
        completions: {
          algorithm: "fuzzy",
        }
      }
    '';
  };
  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    plugins = [
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.20.0";
          sha256 = "sha256-ES5vJXHjAKw/VHjWs8Au/3R+/aotSbY7PWnWAMzCR8E=";
        };
      }
      {
        name = "fzf-tab";
        file = "fzf-tab.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
        };
      }
      {
        name = "zsh-editing-workbench";
        src = pkgs.fetchFromGitHub {
          owner = "z-shell";
          repo = "zsh-editing-workbench";
          rev = "v1.0.0";
          sha256 = "sha256-06uxsCyIY+fydZCB+sjb5qcsLBEk1zrRtWGav3lrstQ=";
        };
      }
    ];
    #completionInit = "";
    initExtraFirst = ''
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
    '';
    initExtra = ''
      [[ ! -f ~/.cargo/env ]] || source ~/.cargo/env
      [[ ! -f ~/.zsh_extra ]] || source ~/.zsh_extra
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      CASE_SENSITIVE="true"
      export PATH=~/.local/bin:$PATH
      bindkey "^J" accept-line
      export MANPAGER="${pkgs.less}/bin/less -M -R -i --use-color -Dd+R -Du+B -DHkC -j5"
      export MANROFFOPT="-c"
      export EDITOR="vim"
    '';
  };
}
