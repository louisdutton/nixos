{ pkgs, ... }:
{
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    gh
    glab
    nodejs
    ripgrep
    awscli2
    dotnet-sdk
    maven
  ];

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
    VISUAL = "nvim";
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/Cloudflare_CA.pem";
  };

  programs.java = {
    enable = true;
    package = pkgs.openjdk8;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      keybindings = {
        universal = {
          nextTab = "l";
          prevTab = "h";
          "nextBlock-alt" = false;
          "prevBlock-alt" = false;
        };
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Louis Dutton";
    userEmail = "louis.dutton@travelchapter.com";
    extraConfig = {
      pull = {
        rebase = false;
      };
      credential = {
        "https://gitlab.com".helper = "!glab auth git-credential";
      };
    };
  };

  programs.bat = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship.enable = true;
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;

    shellAliases = {
      config = "sudo nvim /etc/nixos/";
      rebuild = "sudo NIX_SSL_CERT_FILE=/etc/ssl/certs/Cloudflare_CA.pem nixos-rebuild switch";
      s = "sudo NIX_SSL_CERT_FILE=/etc/ssl/certs/Cloudflare_CA.pem nix-shell -p";
      c = "clear";
      e = "nvim";
      se = "sudo nvim";
      g = "lazygit";
      sg = "sudo lazygit";
      cat = "bat";
    };

    initExtra = ''
      # vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # viins
      bindkey "^H" backward-delete-char
      bindkey "^?" backward-delete-char
      bindkey '^[^?' backward-kill-word

      # vicmd
      bindkey -M vicmd "H" vi-beginning-of-line
      bindkey -M vicmd "L" vi-end-of-line

      # Change cursor shape for different vi modes.
      function zle-keymap-select {
      	if [[ $KEYMAP == vicmd ]] ||
      		 [[ $1 = "block" ]]; then
      		echo -ne "\e[1 q"
      	elif [[ $KEYMAP == main ]] ||
      			 [[ KEYMAP == viins ]] ||
      			 [[ KEYMAP = "" ]] ||
      			 [[ $1 = "beam" ]]; then
      		echo -ne "\e[5 q"
      	fi
      }
      zle -N zle-keymap-select
      zle-line-init() {
      		zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
      		echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne "\e[5 q" # Use beam shape cursor on startup.
      preexec() { echo -ne "\e[5 q" ;} # Use beam shape cursor for each new prompt.
    '';

    completionInit = ''
      autoload -Uz compinit                                   	# autoload completion
      compinit                                                	# initialise completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'     	# case-insensitive completion
      zstyle ':completion:*' menu select                      	# menu selection
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" # list colors
      bindkey '^[[Z' reverse-menu-complete                    	# shift-tab to navigate backwards
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END
      setopt MENU_COMPLETE
      setopt COMPLETE_IN_WORD
    '';
  };
}
