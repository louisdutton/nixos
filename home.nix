{ pkgs, ...}:
{
  home.stateVersion = "23.11";

	home.packages = with pkgs; [
		gh
		glab
		nodejs
		yarn
	];

	programs.git = {
		enable = true;
		userName = "Louis Dutton";
		userEmail = "louis.dutton@travelchapter.com";
	};

	programs.lazygit.enable = true;
  programs.starship.enable = true;
  programs.zsh = {
		enable = true;
		# enableLsColors = true;
		enableCompletion = true;
		shellAliases = {
			rebuild = "sudo NIX_SSL_CERT_FILE=/etc/ssl/certs/Cloudflare_CA.pem nixos-rebuild switch";
			config = "sudo nvim /etc/nixos/";
			c = "clear";
			e = "nvim";
			g = "lazygit";
		};
	};
}
