{ pkgs, user, ... }:
{
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    glab
    nodejs
    yarn
    sd
    maven
    xh
  ];

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
    VISUAL = "nvim";
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/Cloudflare_CA.pem";
  };

  programs.awscli = {
    enable = true;
    settings =
      let
        region = "eu-west-1";
        profile = id: {
          sso_session = "travelchapter";
          sso_account_id = id;
          sso_role_name = "TC-Developer-Access-Dev";
          region = region;
          output = "json";
        };
      in
      {
        "sso-session travelchapter" = {
          sso_start_url = "https://travelchapter.awsapps.com/start";
          sso_region = region;
          sso_registration_scopes = "sso:account:access";
        };
        "profile data-dev" = profile "327913457104";
        "profile hub-dev" = profile "809561633273";
      };
  };

  programs.bun = {
    enable = true;
    settings = {
      telemetry = false;
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.openjdk17;
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

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    userName = user.displayName;
    userEmail = user.email;
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
    config = {
      theme = "catppuccin";
    };
    themes = {
      catppuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
          sha256 = "Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };

  home.file.".config/btop/themes/catppuccin.theme" = {
    source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/main/themes/catppuccin_mocha.theme";
      sha256 = "0i263xwkkv8zgr71w13dnq6cv10bkiya7b06yqgjqa6skfmnjx2c";
    };
  };
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.fzf =
    let
      fdFile = "fd --type f";
      fdDir = "fd --type f";
    in
    {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = fdFile;
      fileWidgetCommand = fdFile;
      changeDirWidgetCommand = fdDir;
      colors = {
        "bg" = "-1";
        "bg+" = "#313244";
        "spinner" = "#f5e0dc";
        "hl" = "#f38ba8";
        "hl+" = "#f38ba8";
        "fg" = "#cdd6f4";
        "fg+" = "#cdd6f4";
        "header" = "#f38ba8";
        "info" = "#cba6f7";
        "pointer" = "#f5e0dc";
        "marker" = "#f5e0dc";
        "prompt" = "#cba6f7";
      };
    };

  programs.starship.enable = true;
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;

    shellAliases = {
      rebuild = "nh os switch";
      c = "clear";
      e = "nvim";
      se = "sudo nvim";
      g = "lazygit";
      sg = "sudo lazygit";
      cat = "bat";
      sso = "aws sso login --sso-session travelchapter";
      tree = "ls --tree --git-ignore";
      gl = "glab";

      # mulesoft
      mule-redeploy =
        let
          job = "Deploy to develop";
        in
        "gl ci retry '${job}' && gl ci trace '${job}'";
    };

    plugins = [
      {
        name = "zsh-system-clipboard";
        src = pkgs.fetchFromGitHub {
          owner = "kutsan";
          repo = "zsh-system-clipboard";
          rev = "v0.8.0";
          sha256 = "VWTEJGudlQlNwLOUfpo0fvh0MyA2DqV+aieNPx/WzSI=";
        };
      }
    ];

    initExtra = # bash
      ''
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

        # nix shell alias that maps arg -> nixpkgs#arg
        function s() {
        	args=("$@")
        	nix shell ''${args[@]/#/nixpkgs#}
        }
      '';
    completionInit = # bash
      ''
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
