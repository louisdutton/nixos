{ config, lib, pkgs, ... }:
{
  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  wsl.enable = true;
  wsl.defaultUser = "louis";
  wsl.nativeSystemd = true;
  networking.hostName = "PF3X11W5";
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.louis = {
    isNormalUser = true;
  };

  #security.pki.certificateFiles = [
    # "/etc/ssl/certs/Cloudflare_CA.pem"
  #  "/etc/ssl/certs/ca-bundle.crt"
  #  "/etc/ssl/certs/ca-certificates.crt"
  #];

  #security.sudo.extraConfig = ''
  #  Defaults env_keep += "NIX_SSL_CERT_FILE"
  #  Defaults env_keep += "SSL_CERT_FILE"
  #'';

  #environment.variables = {
  #  NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
  #  SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
  #};
}
