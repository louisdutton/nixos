{ pkgs, ...}:
{
  home.stateVersion = "23.11";

	home.packages = with pkgs; [
		gh
		glab
		nodejs
		yarn
		ripgrep
	];

	home.sessionVariables = {
		MANPAGER = "nvim +Man!";
		EDITOR = "nvim";
		VISUAL = "nvim";
	};

	programs.git = {
		enable = true;
		userName = "Louis Dutton";
		userEmail = "louis.dutton@travelchapter.com";
	};

	programs.zoxide = {
		enable = true;
		enableZshIntegration = true;
		options = [ "--cmd cd" ];
	};

  programs.zsh = {
		enable = true;
		autocd = true;
		enableCompletion = true;

		shellAliases = {
			rebuild = "sudo NIX_SSL_CERT_FILE=/etc/ssl/certs/Cloudflare_CA.pem nixos-rebuild switch";
			config = "sudo nvim /etc/nixos/";
			c = "clear";
			e = "nvim";
			g = "lazygit";
		};

		initExtra = ''
			# vi mode
			bindkey -v
			bindkey "^H" backward-delete-char
			bindkey "^?" backward-delete-char
			export KEYTIMEOUT=1

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
	};

	programs.lazygit.enable = true;
  programs.starship.enable = true;
}
