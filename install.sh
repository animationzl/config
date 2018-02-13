#!/bin/bash

cd $(dirname "$0")

# Install packages
while read pkg
do
    apt install -y $pkg
done < apt-packages

if [[ ! -e ~/.zshrc ]]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    sed -i '/^ZSH_THEME/c ZSH_THEME="bira"' ~/.zshrc
    { echo; cat shell-aliases; } >> ~/.zshrc
    chsh -s $(which zsh)
fi

if [[ ! -e ~/.tmux.conf ]]; then
    cp .tmux.conf ~/.tmux.conf
fi

if [[ ! -e ~/.vimrc ]]; then
    cp .vimrc ~/.vimrc

    # Install tpope/vim-pathogen
    if [[ ! -e ~/.vim/autoload/pathogen.vim ]]; then
        mkdir -p ~/.vim/autoload ~/.vim/bundle && \
            curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    fi

    # Install vim plugins
    while read repo
    do
        short_name=${repo##*/}
        if [[ ! -d ~/.vim/bundle/$short_name ]]; then
            git clone https://github.com/$repo ~/.vim/bundle/$short_name
        fi
    done < vim-plugins
fi
