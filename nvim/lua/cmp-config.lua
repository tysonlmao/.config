local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body) -- Snippet engine
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(), -- Show completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
    ['<Tab>'] = cmp.mapping.select_next_item(), -- Move down
    ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Move up
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP-based completion
    { name = 'luasnip' },  -- Snippets
    { name = 'buffer' },   -- Buffer words
    { name = 'path' },     -- File paths
  })
})

-- Enable completion in command mode (for :commands)
cmp.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})

