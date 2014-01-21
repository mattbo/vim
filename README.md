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
    git clone https://github.com/gmarik/vundle.git vundle
    vim +BundleInstall +qall
    

