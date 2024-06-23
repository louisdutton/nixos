{ pkgs, user, ... }:
{
  system.stateVersion = "23.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.hostName = user.hostName;
  programs.zsh.enable = true;
  programs.nh = {
    enable = true;
    flake = user.flake;
  };
  users = {
    defaultUserShell = pkgs.zsh;
    users.${user.name}.isNormalUser = true;
  };
}
