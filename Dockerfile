FROM ubuntu:disco

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -yq git \
silversearcher-ag \
python \
python-dev \
python3 \
python3-dev \
python3-pip \
neovim \
bash \
curl \
wget \
tar \
gcc \
make \
zsh \
tmux \
docker \
mosh \
ca-certificates \
php

# install neovim plugins
RUN pip3 install --upgrade pip setuptools && \
pip3 install neovim && \
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mkdir -p ~/.config/nvim/plugged
COPY ./init.vim /root/.config/nvim/init.vim

# install zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
RUN rm -f ~/.zshrc
RUN chsh -s $(which zsh)

# my dot files
RUN cd /root && git clone https://github.com/andre-karrlein/dot-ak1.git
RUN ln -s /root/dot-ak1/tmux.conf ~/.tmux.conf && ln -s /root/dot-ak1/zshrc ~/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# create code dir
RUN mkdir /root/code
WORKDIR /root

#install go
RUN curl -s https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz| tar -v -C /usr/local -xz
ENV PATH $PATH:/usr/local/go/bin

RUN go version

RUN nvim --headless -c "PlugInstall! | qall! " && \
nvim --headless +UpdateRemotePlugins +qall

# install kubectl
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod 755 /usr/local/bin/kubectl

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

# install gcloud
RUN curl -sSL https://sdk.cloud.google.com | /bin/zsh
ENV PATH $PATH:/root/google-cloud-sdk/bin

RUN git config --global user.email "andre@karrlein.com"
RUN git config --global user.name "Andre Karrlein"

EXPOSE 6001/udp

#RUN mosh-server

ENTRYPOINT [ "/bin/zsh" ]
