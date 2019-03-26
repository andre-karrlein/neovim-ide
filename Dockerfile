FROM alpine:latest

RUN apk add --update \
git \
linux-headers \
unzip \
the_silver_searcher \
curl \
python \
neovim \
python-dev \
bash \
gcc \
make \
go \
zsh \
tmux \
musl-dev \
&& rm -rf /var/cache/apk/*

RUN apk add --update-cache --no-cache git python3 && \
apk add --no-cache --virtual build-deps musl-dev gcc python3-dev && \
python3 -m ensurepip && \
pip3 install --upgrade pip setuptools && \
pip3 install neovim && \
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
#RUN cd /home && git clone https://github.com/andre-karrlein/dot-ak1.git && ln -s /home/dot-ak1/tmux.conf ~/.tmux.conf && source ~/.tmux.conf

RUN mkdir -p ~/.config/nvim/plugged
COPY ./init.vim /root/.config/nvim/init.vim

RUN nvim --headless -c "PlugInstall! | qall! " && \
nvim --headless +UpdateRemotePlugins +qall

RUN cd /root/go/bin && go get -u github.com/cweill/gotests/...

RUN mkdir /home/code
WORKDIR /home

ENTRYPOINT [ "/bin/zsh" ]
