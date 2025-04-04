require("keymaps")
require("plugins")

-- Ensure Packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd 'packadd packer.nvim'
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'  -- Packer itself
  use 'nvim-telescope/telescope.nvim'  -- Telescope
  use 'nvim-lua/plenary.nvim'  -- Required dependency for Telescope

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Load Telescope *after* plugins are loaded
pcall(require, 'telescope')

