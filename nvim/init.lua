vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/stevearc/oil.nvim'
}

-- vim.cmd.packadd('cfilter')
vim.cmd.packadd('nvim.undotree')
vim.cmd.packadd('nvim.difftool')

-- Enables experimental ui
-- require('vim._core.ui2').enable {
--     msg = {
--         target = 'cmd',
--         cmd = { height = 1 }
--     }
-- }

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.g.mapleader = ' '
-- allows for local project-specific config, can be dangerous so turned off
-- vim.opt.exrc = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = '80'
vim.opt.textwidth = 80
vim.opt.completeopt = 'menu,menuone,fuzzy,noinsert'
vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.wildoptions:append { 'fuzzy' }
vim.opt.nrformats:append { 'blank', 'alpha' }
vim.opt.path:append { '**' }
vim.opt.smoothscroll = true
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'
-- seems like a decent status line. can always edit this if you don't like it
vim.opt.statusline = '[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P'
vim.opt.foldlevel = 999
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.tabstop = 4

vim.cmd.colorscheme('catppuccin')

-- disable mouse popup yet keep mouse enabled
vim.cmd [[
  aunmenu PopUp
  autocmd! nvim.popupmenu
]]

-- Only highlight with treesitter
-- vim.cmd('syntax off')

require('oil').setup {
    keymaps = { ['<C-h>'] = false },
    columns = { 'size', 'mtime' },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
}

-- Keymaps
vim.keymap.set('n', '<leader><leader>', ':Oil<CR>', { silent = true })

vim.keymap.set('n', '<leader>a', function()
    vim.cmd('$argadd %')
    vim.cmd('argdedup')
end)
-- these are for switching current buffer based on arglist. might need to tweak
-- shortcuts though
vim.keymap.set('n', '<C-h>', function() vim.cmd('silent! 1argument') end)
vim.keymap.set('n', '<C-j>', function() vim.cmd('silent! 2argument') end)
vim.keymap.set('n', '<C-k>', function() vim.cmd('silent! 3argument') end)
vim.keymap.set('n', '<C-n>', function() vim.cmd('silent! 4argument') end)
vim.keymap.set('n', '<C-m>', function() vim.cmd('silent! 5argument') end)

vim.keymap.set('n', 'gl', vim.diagnostic.open_float, {desc = 'Show line diagnostics' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {desc = 'Show line diagnostics' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>w', '<C-w>', {desc = 'Leader w for window mode'}) 
-- Autocommands
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.o.signcolumn = 'yes:1'
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.o.complete = 'o,.,w,b,u'
            vim.o.completeopt = 'menu,menuone,popup,noinsert,fuzzy'
			-- change autotrigger if you want, else use <C-n>
            vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = false})
        end
		if client:supports_method('textDocument/inlayHint') then
				vim.lsp.inlay_hint.enable(true, {bufnr = args.buf})
		end
    end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.hl.on_yank() end,
})


vim.lsp.enable('rust_analyzer')
vim.lsp.enable('zuban')
