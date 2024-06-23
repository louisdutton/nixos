{ pkgs, user, ... }:
{
  wsl = {
    enable = true;
    defaultUser = user.name;
    nativeSystemd = true;
  };

  # enable opening links
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "xdg-open" "exec -a $0 ${pkgs.wsl-open}/bin/wsl-open $@")
  ];
}
