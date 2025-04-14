{ config, pkgs, ... }: {
  # shell
  home.packages = with pkgs; [ lsd zoxide ];
  programs.starship.enable = true;
  programs.starship.settings = {
    format =
      "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
    directory.style = "blue";
    character = {
      success_symbol = "[❯](purple)";
      error_symbol = "[❯](red)";
      vimcmd_symbol = "[❮](green)";
    };
    git_branch = {
      format = "[$branch]($style)";
      style = "bright-black";
    };
    git_status = {
      format =
        "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
      style = "cyan";
      conflicted = "​";
      untracked = "​";
      modified = "​";
      staged = "​";
      renamed = "​";
      deleted = "​";
      stashed = "≡";
    };
    git_state = {
      format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
      style = "bright-black";
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "yellow";
    };
    python = {
      format = "[$virtualenv]($style) ";
      style = "bright-black";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      alias old_ls="ls"
      alias ls="lsd"
      set fish_greeting
      starship init fish | source
      zoxide init fish --cmd cd | source
    '';
  };
}
