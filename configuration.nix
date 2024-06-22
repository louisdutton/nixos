{ pkgs, ... }:
{
  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "PF3X11W5";
  programs.zsh.enable = true;

	wsl = {
		enable = true;
		defaultUser = "louis";
		nativeSystemd = true;
	};

	users = {
		defaultUserShell = pkgs.zsh;
		users.louis = {
			isNormalUser = true;
		};
	};
}
