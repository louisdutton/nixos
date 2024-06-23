{ ... }:
{
  imports = [
    ./keymaps.nix
    ./lsp.nix
    ./format.nix
    ./options.nix
    ./autocmd.nix
    ./completion.nix
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        transparent_background = true;
      };
    };

    plugins = {
      lualine.enable = true;
      commentary.enable = true;
      treesitter.enable = true;
      treesitter-textobjects.enable = true;
      oil.enable = true;
      noice.enable = true;

      gitsigns = {
        enable = true;
        settings = {
          signcolumn = true;
          numhl = true;
          current_line_blame = false;
          current_line_blame_opts = {
            delay = 0;
            virt_text = true;
            virt_text_pos = "eol";
          };
          watch_gitdir.follow_files = true;
          signs = {
            add.text = "┃";
            change.text = "┃";
            changedelete.text = "~";
            delete.text = "_";
            topdelete.text = "‾";
            untracked.text = "┆";
          };
        };
      };

      lazygit = {
        enable = true;
        gitPackage = null;
        lazygitPackage = null;
      };

      surround = {
        enable = true;
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>t" = "builtin";
          "<leader>f" = "find_files";
          "<leader>/" = "live_grep";
          "?" = "current_buffer_fuzzy_find";
        };
      };
    };
  };
}
