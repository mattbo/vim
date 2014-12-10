vim
===

My Vim configuration

Installation
===

    cd ~ 
    git clone https://github.com/mattbo/vim .vim
    ln -s .vim/vimrc.vimrc .vimrc
    cd .vim
    mkdir bundle
    cd bundle
    git clone https://github.com/gmarik/Vundle.vim.git Vundle.vim
    cd ~
    vim +BundleInstall +qall
    

