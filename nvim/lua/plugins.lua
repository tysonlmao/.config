return require('packer').startup(function(use)
    use 'nvim-telescope/telescope.nvim'  -- Fuzzy finder
    use 'nvim-lua/plenary.nvim'          -- Required dependency
end)

