The settings of my vim editor. Please put resources/colors and vimrc file at ~/.vim/ and ~/.vimrc respectively. 

In resources/colors, there are some color files used in my vim. 

Belowing VIM PLUGINS are now under use: 

* [pathogen.vim](https://github.com/tpope/vim-pathogen)

  pathogen.vim makes it super easy to install plugins. Other settings are included in .vimrc
  ```shell
  mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  
  cd ~/.vim/bundle && git clone <https://github.com/tpope/vim-sensible.git>
  ```
* [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object): Defines a new text object representing lines of code at the same indent level. Useful for python/vim scripts
* [syntastic](https://github.com/vim-syntastic/syntastic): Syntax checking hacks for vim
* [snipMate.vim](https://github.com/garbas/vim-snipmate): snipMate.vim aims to be a concise vim script that implements some of TextMate's snippets features in Vim
* [lightline.vim](https://github.com/itchyny/lightline.vim): A light and configurable statusline/tabline for Vim
* [vim-yankstack](https://github.com/maxbrunsfeld/vim-yankstack): Maintains a history of previous yanks, changes and deletes
* [vim-lastplace](https://github.com/farmergreg/vim-lastplace): Intelligently reopen files at your last edit position
* [NERDTree](https://github.com/scrooloose/nerdtree): NERDTree

vimrc file

```

"========================================== 

"Plugin: pathogen

"========================================== 

execute pathogen#infect()

syntax on

filetype plugin indent on

"========================================== 

"General 

"========================================== 

set history=500 " history length

set shortmess=atI " block the information shown at launch

set nobackup " Turn backup off

set nowb

set noswapfile

color peaksea " color scheme

if ! has("gui_running") 

 set t_Co=256 

endif 

set background=dark " background

set autoread " file is automatically reloaded after modification

set number " set line numbers

set magic " magic

set novisualbell " no visual bell

syntax enable on " syntax 

set ruler " show current line number and column number

"========================================== 

"Search and Show

"========================================== 

set showmatch " Show matching brackets when text indicator is over them

set mat=2 " How many tenths of a second to blink when matching brackets

set ignorecase " Ignore case when searching

set smartcase " When searching try to be smart about cases 

set hlsearch " Highlight search results

set incsearch " Makes search act like search in modern browsers

"========================================== 

"Encoding

"========================================== 

set encoding=utf-8

set fileencoding=utf-8

set fileencodings=utf-8,chinese,ucs-bom

set termencoding=utf-8

set nobomb

"========================================== 

"Plugin: syntastic

"========================================== 

set statusline+=%#warningmsg#

set statusline+=%{SyntasticStatuslineFlag()}

set statusline+=%*

let g:syntastic_always_populate_loc_list = 1

let g:syntastic_auto_loc_list = 1

let g:syntastic_check_on_open = 0

let g:syntastic_check_on_wq = 0

"==========================================

"Plugin: lightline

"==========================================

set laststatus=2

let g:lightline = {'colorscheme': 'wombat',}

"==========================================

"Plugin: YankStack

"==========================================

nmap <leader>p <Plug>yankstack_substitute_older_paste

nmap <leader>P <Plug>yankstack_substitute_newer_paste

"==========================================

"Plugin: NERDTree

"==========================================

map <C-n> :NERDTreeToggle<CR>
```