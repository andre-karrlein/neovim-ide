FROM alpine:latest
MAINTAINER André Karrlein <andre@karrlein.com>

RUN apk add --update \ 
git \
linux-headers \
unzip \
python \
python-dev \
py-pip \
neovim \
&& rm -rf /var/cache/apk/*

RUN curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mkdir -p ~/.config/nvim/plugged
COPY init.vim ~/.config/nvim/init.vim

RUN nvim +PlugInstall +UpdateRemotePlugins +qa

ENV TERM xterm256-color

RUN mkdir /code
WORKDIR /code

CMD nvim
