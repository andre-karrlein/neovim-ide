FROM alpine:latest
MAINTAINER André Karrlein <andre@karrlein.com>

RUN apk add --update \
git \
linux-headers \
unzip \
the_silver_searcher \
curl \
python \
neovim \
php \
php7-tokenizer \
php7-dom \
php7-mbstring \
php7-xmlwriter \
php7-xml \
composer \
python-dev \
bash \
gcc \
make \
go \
&& rm -rf /var/cache/apk/*

RUN apk add --update-cache --no-cache git python3 && \
apk add --no-cache --virtual build-deps musl-dev gcc python3-dev && \
python3 -m ensurepip && \
pip3 install --upgrade pip setuptools && \
pip3 install neovim && \
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mkdir -p ~/.config/nvim/plugged
COPY ./init.vim /root/.config/nvim/init.vim

RUN nvim --headless -c "PlugInstall! | qall! " && \
nvim --headless +UpdateRemotePlugins +qall

RUN cd /root/.config/nvim/plugged/phpactor && \
composer install

ENV TERM xterm256-color

RUN mkdir /code
WORKDIR /code

CMD nvim
