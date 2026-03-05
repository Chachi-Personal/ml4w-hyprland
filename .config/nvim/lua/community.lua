-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder

  -- UI
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.color.transparent-nvim" },
  { import = "astrocommunity.syntax.hlargs-nvim" },
  -- { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.recipes.vscode-icons" },
  { import = "astrocommunity.utility.noice-nvim" },

  -- Languages
  -- -- Coding
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.black" },
  { import = "astrocommunity.pack.python.isort" },

  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.eslint" },

  { import = "astrocommunity.pack.cpp" },

  { import = "astrocommunity.pack.rust" },

  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.prettier" },
  -- { import = "astrocommunity.pack.prisma" },

  --
  { import = "astrocommunity.pack.laravel" },
  { import = "astrocommunity.pack.blade" },
  { import = "astrocommunity.pack.php" },

  { import = "astrocommunity.pack.hyprlang" },

  -- -- Notes
  { import = "astrocommunity.pack.typst" },
  { import = "astrocommunity.pack.markdown" },
  -- { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  --
  -- { import = "astrocommunity.markdown-and-latex.peek-nvim" },
  -- { import = "astrocommunity.note-taking.neorg" },
  -- { import = "astrocommunity.markdown-and-latex.markview-nvim" },

  -- Completion
  -- { import = "astrocommunity.completion.blink-cmp" },

  -- -- Copilot
  -- { import = "astrocommunity.completion.copilot-lua" },
  -- { import = "astrocommunity.completion.copilot-cmp" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.completion.avante-nvim" },

  -- Comment
  -- { import = "astrocommunity.comment.ts-comments-nvim" },

  -- Utils
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.recipes.neovide" },
  { import = "astrocommunity.editing-support.true-zen-nvim" },
  { import = "astrocommunity.terminal-integration.flatten-nvim" },
  { import = "astrocommunity.terminal-integration.vim-tmux-navigator" },

  { import = "astrocommunity.media.image-nvim" },
}
