return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Your other plugins
    use 'nvim-telescope/telescope.nvim'  -- Fuzzy finder
    use 'nvim-lua/plenary.nvim'          -- Required dependency

    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)

