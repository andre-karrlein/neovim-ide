FROM alpine:latest
MAINTAINER André Karrlein <andre@karrlein.com>

RUN apk add --update \
git \
linux-headers \
unzip \
the_silver_searcher \
curl \
python3 \
python \
python-dev \
python3-dev \
py3-pip \
neovim \
&& rm -rf /var/cache/apk/*

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mkdir -p ~/.config/nvim/plugged
COPY ./init.vim /root/.config/nvim/init.vim

RUN nvim +PlugInstall +UpdateRemotePlugins +qa

ENV TERM xterm256-color

RUN mkdir /code
WORKDIR /code

CMD nvim
