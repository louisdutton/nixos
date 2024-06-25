{
  programs.nixvim.plugins = {
    lsp-lines = {
      enable = true;
      currentLine = true;
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
        nil-ls.enable = true;
        nixd = {
          enable = true;
          # options = {
          #   nixos.expr =
          #     (builtins.getFlake "/home/louis/.config/nixos").nixosConfigurations.${user.hostName}.options;
          # };
        };
      };
    };
  };
}
