local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.default_capabilities()

lspconfig.pyright.setup { capabilities = capabilities } -- Example: Python LSP
lspconfig.tsserver.setup { capabilities = capabilities } -- Example: JavaScript LSP

