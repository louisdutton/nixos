{ pkgs, user, ... }:
{
  system.stateVersion = "23.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.hostName = user.hostName;
  users = {
    defaultUserShell = pkgs.zsh;
    users.${user.name}.isNormalUser = true;
  };

  programs.zsh.enable = true;
  programs.nh = {
    enable = true;
    flake = user.flake;
  };
  environment.systemPackages = with pkgs; [ xclip ];
}
