{ ... }:
{
  security.pki.certificates =
    let
      cloudflare = builtins.readFile (
        builtins.fetchurl {
          url = "https://developers.cloudflare.com/cloudflare-one/static/Cloudflare_CA.pem";
          sha256 = "1mal8zm9m7a2pb1n9j361xly3vlk1a99s3hbci9jvkvvmrivx7gf";
        }
      );
    in
    [ cloudflare ];
}
