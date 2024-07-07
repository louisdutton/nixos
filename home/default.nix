{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./git.nix
    ./aws.nix
    ./javascript.nix
    ./rust.nix
    ./java.nix
  ];

  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    sd
    xh
    jq
  ];

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # languages
  javascript.enable = true;
  rust.enable = true;
  java.enable = true;
}
