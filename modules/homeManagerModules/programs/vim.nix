{
pkgs,
config,
...
}: {

  programs.vim = {
    enable = false;
    # settings = { ignorecase = true; };
    # plugins = with pkgs.vimPlugins; [ 
    #   vim-which-key 
    #   vim-markdown
    #   #bullets-vim
    # ];
    extraConfig = ''
      set path+=**/* nocompatible incsearch smartcase ignorecase termguicolors background=dark mouse-=a
      set wildmenu wildignorecase


      "" editing
      filetype plugin indent on
      set noswapfile confirm scrolloff=20
      set autoindent expandtab tabstop=2 shiftwidth=2
      "" argadd ~/Productivity/notes ~/Productivity/planning/* ~/flake/configuration.nix  " add this single dir and file to my buffer list


      "" Netrw
      let g:netrw_banner = 0
      "autocmd FileType netrw call feedkeys("/\<c-u>", 'n')


      "" Shortcuts
      let mapleader=" "
      nnoremap <leader>f :edit %:p:h/*<C-D>
      nnoremap <leader>F :edit %:p:h/*<C-D>*/*
      nnoremap <leader>g :grep -IrinE "" .<Left><Left><Left>
      nnoremap <leader>G :vimgrep "//" %<Left><Left><Left><Left>
      nnoremap <leader>w :update<CR>
      nnoremap <leader>q :xa<CR>
      nnoremap <leader>x :close<CR>
      nnoremap <leader>o :browse oldfiles<CR>
      " TODO save and reload vimrc from anywhere
      vnoremap <leader>y "+y
      "nnoremap <leader>b :ls<CR>:buffer<space>
      nnoremap <leader>b :buffer<Space><C-D>
      "nnoremap <leader>n :set rnu! cursorline! list! noshowmode!<CR>
      nnoremap <leader>n :cn<CR>
      nnoremap <leader>p :cp<CR>
      nnoremap <leader>c :cope<CR>


      function Term()
        cd %:p:h | execute 'bo ter++rows=10' | tcd
      endfunction
      nnoremap <leader>t :call Term()<CR>


      "" vanity
      syntax on
      "set termguicolors background=dark 
      set laststatus=0 shortmess+=I noshowmode
      set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:
      "let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'haskell', 'cpp']
    '';
  };
}
