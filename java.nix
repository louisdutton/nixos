{
  pkgs,
  config,
  lib,
  user,
  ...
}:
{
  environment.variables.JAVAX_NET_SSL_TRUSTSTORE =
    let
      caBundle = config.environment.etc."ssl/certs/ca-certificates.crt".source;
      p11kit = pkgs.p11-kit.overrideAttrs (oldAttrs: {
        mesonFlags = [
          "--sysconfdir=/etc"
          (lib.mesonEnable "systemd" false)
          (lib.mesonOption "bashcompdir" "${placeholder "bin"}/share/bash-completion/completions")
          (lib.mesonOption "trust_paths" (lib.concatStringsSep ":" [ "${caBundle}" ]))
        ];
      });
    in
    derivation {
      name = "java-cacerts";
      builder = pkgs.writeShellScript "java-cacerts-builder" ''
        ${p11kit.bin}/bin/trust \
        	extract \
        	--format=java-cacerts \
        	--purpose=server-auth \
        	$out
      '';
      system = user.system;
    };
}
