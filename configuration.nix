{ pkgs, config, lib, ... }:
{
  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "PF3X11W5";
  programs.zsh.enable = true;

	environment.systemPackages = [
  	(pkgs.writeShellScriptBin "xdg-open" "exec -a $0 ${pkgs.wsl-open}/bin/wsl-open $@")
	];

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

	security.pki.certificates =
		let
			cloudflare = builtins.readFile(builtins.fetchurl {
				url = "https://developers.cloudflare.com/cloudflare-one/static/Cloudflare_CA.pem";
				sha256 = "1mal8zm9m7a2pb1n9j361xly3vlk1a99s3hbci9jvkvvmrivx7gf";
			});
		in
		[
			cloudflare
		];

	environment.variables.JAVAX_NET_SSL_TRUSTSTORE =
		let
			caBundle = config.environment.etc."ssl/certs/ca-certificates.crt".source;
			p11kit = pkgs.p11-kit.overrideAttrs (oldAttrs: {
				mesonFlags = [
					"--sysconfdir=/etc"
					(lib.mesonEnable "systemd" false)
					(lib.mesonOption "bashcompdir" "${placeholder "bin"}/share/bash-completion/completions")
					(lib.mesonOption "trust_paths" (lib.concatStringsSep ":" [
						"${caBundle}"
					]))
				];
			});
		in derivation {
			name = "java-cacerts";
			builder = pkgs.writeShellScript "java-cacerts-builder" ''
				${p11kit.bin}/bin/trust \
					extract \
					--format=java-cacerts \
					--purpose=server-auth \
					$out
			'';
      system = "x86_64-linux";
		};
}
