{ pkgs, ...}:
{
  home.stateVersion = "23.11";

	home.packages = with pkgs; [
		gh
		glab
		nodejs
		yarn
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
	};

	programs.lazygit.enable = true;
  programs.starship.enable = true;
}
