let
	gmap = k: a: { key = k; action = a; };
	nmap = k: a: { key = k; action = a; mode = "n"; };
in
{
	programs.nixvim = {
  	enable = true;

		colorschemes.base16 = {
			enable = true;
			colorscheme = "everforest";
			setUpBar = true;
		};

		plugins = {
			lualine.enable = true;
			commentary.enable = true;
			surround.enable = true;
			treesitter.enable = true;
			treesitter-textobjects.enable = true;

			indent-blankline = {
				enable = true;
				settings = {
				 exclude = {
					 buftypes = [
						 "terminal"
						 "quickfix"
					 ];
					 filetypes = [
						 ""
						 "checkhealth"
						 "help"
						 "lspinfo"
						 "TelescopePrompt"
						 "TelescopeResults"
					 ];
				 };
				 indent = {
					 char = "│";
				 };
				 scope = {
					 show_end = false;
					 show_exact_scope = true;
					 show_start = false;
				 };
				};
			};

			telescope = {
				enable = true;
				keymaps = {
					"<leader>ff" = "find_files";
					"<leader>fc" = "commands";
					"<leader>fs" = "symbols";
					"<leader>fd" = "diagnostics";
					"<leader>fg" = "live_grep";
					"<leader>fq" = "quickfix";
					"<leader>fo" = "oldfiles";
					"<leader>fh" = "help_tags";
					"<leader>fm" = "man_pages";
					"<leader>ft" = "builtin";
					"<leader>/" = "current_buffer_fuzzy_find";
				};
			};

			cmp = {
				enable = true;
				autoEnableSources = true;
				settings.sources = [
					{name = "nvim_lsp";}
					{name = "path";}
					{name = "buffer";}
					{name = "luasnip";}
				];
				settings.formatting.fields = [ "kind" "abbr" "menu" ];
        settings.mapping = {
				 "<C-Space>" = "cmp.mapping.complete()";
				 "<C-d>" = "cmp.mapping.scroll_docs(-4)";
				 "<C-e>" = "cmp.mapping.close()";
				 "<C-f>" = "cmp.mapping.scroll_docs(4)";
				 "<CR>" = "cmp.mapping.confirm({ select = true })";
				 "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
				 "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
			 	};
			};

			lsp = {
				enable = true;

				servers = {
					nil_ls.enable = true;
					tsserver.enable = true;
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
						"<leader>bf" = "format";
          };
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

			# redo
			(nmap "U" "<c-r>")
		];

		autoCmd = [
			{
				event = [ "TextYankPost" ];
				pattern = "*";
				callback = { __raw = "function() vim.highlight.on_yank() end"; };
			}
		];
	};
}
