{ pkgs, user, ... }:
{
  programs.nixvim.plugins = {
    lspkind = {
      enable = true;
      cmp.enable = true;
    };

    lsp = {
      enable = true;
      servers = {
        tsserver.enable = true;
        html.enable = true;
        lemminx.enable = true;
        java-language-server.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        taplo.enable = true;
        nil-ls.enable = true;
        rust-analyzer = {
          enable = true;
          rustcPackage = pkgs.rustc;
          cargoPackage = pkgs.cargo;
        };
        nixd = {
          enable = true;
          settings = {
            options = {
              # nixos.expr = "(builtins.getFlake ${user.flake}).nixosConfigurations.${user.hostName}.options";
              home-manager.expr = "(builtins.getFlake ${user.flake}).homeConfigurations.${user.name}.options";
              wsl.expr = "(builtins.getFlake ${user.flake}).debug.options";
              # nixvim.expr = "(builtins.getFlake ${user.flake}).debug.options";
            };
          };
        };
      };
    };
  };
}
