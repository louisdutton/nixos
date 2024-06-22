let
  gmap = k: a: {
    key = k;
    action = a;
  };
  nmap = k: a: {
    key = k;
    action = a;
    mode = "n";
  };
in
{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      nixfmt-rfc-style
      prettierd
    ];

    colorschemes.base16 = {
      enable = true;
      colorscheme = "everforest";
      setUpBar = true;
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

      # snippets
      friendly-snippets.enable = true;
      luasnip = {
        enable = true;
        fromVscode = [ { } ];
      };

      # completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "luasnip"; }
        ];
        settings.formatting.fields = [
          "kind"
          "abbr"
          "menu"
        ];
        settings.mapping = {
          "<C-Space>" = "cmp.mapping.complete({ select = true })";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "

						cmp.mapping(function(fallback)
						  local luasnip = require('luasnip')
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expandable() then
								luasnip.expand()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							elseif check_backspace() then
								fallback()
							else
								fallback()
							end
						end, {'i', 's'})";
        };
      };

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          tsserver.enable = true;
          lemminx.enable = true;
          java-language-server.enable = true;
          jsonls.enable = true;
        };

        keymaps = {
          silent = true;
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gr = "references";
            gi = "implementation";
            gt = "type_definition";
            "<leader>a" = "code_action";
            "<leader>k" = "hover";
          };
        };
      };

      conform-nvim = {
        enable = true;
        notifyOnError = true;
        formattersByFt = {
          javascript = [ "prettierd" ];
          typescript = [ "prettierd" ];
          json = [ "prettierd" ];
          yaml = [ "prettierd" ];
          nix = [ "nixfmt" ];
        };
        formatOnSave = {
          lspFallback = true;
          timeoutMs = 500;
        };
      };
    };

    opts = {
      number = true;
      relativenumber = false;
      hlsearch = true;
      tabstop = 2;
      shiftwidth = 2;
      wrap = false;
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      completeopt = "menuone,noselect";
      termguicolors = true;
    };

    globals.mapleader = " ";
    keymaps = [
      # quick commands
      (gmap ";" ":")

      # navigation
      (gmap "H" "^")
      (gmap "L" "$")
      (gmap "K" "gg")
      (gmap "J" "G")

      # delete and change
      (nmap "dH" "d^")
      (nmap "dL" "d$")
      (nmap "cH" "c^")
      (nmap "cL" "c$")

      # surround
      (nmap "siw" "ysiw")
      (nmap "saw" "ysaw")

      # redo
      (nmap "U" "<c-r>")

      # git
      (nmap "<leader>g" ":LazyGit<cr>")
      (nmap "<leader>B" ":Gitsigns toggle_current_line_blame<cr>")
      (nmap "<leader>h" ":Gitsigns preview_hunk<cr>")
    ];

    autoCmd = [
      {
        event = [ "TextYankPost" ];
        pattern = "*";
        callback = {
          __raw = "function() vim.highlight.on_yank() end";
        };
      }
    ];
  };
}
