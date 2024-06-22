{ pkgs, ...}:
{
  home.stateVersion = "23.11";

	home.packages = with pkgs; [
		gh
		glab
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
		syntaxHighlighting.enable = true;
		shellAliases = {
			rebuild = "sudo NIX_SSL_CERT_FILE=/etc/ssl/certs/Cloudflare_CA.pem nixos-rebuild switch";
		};
	};
}
