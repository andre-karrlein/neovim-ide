FROM ubuntu:disco

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco test"
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -yq git \
silversearcher-ag \
iputils \
mysql-client \
python \
python-dev \
python3 \
python3-dev \
python3-pip \
neovim \
bash \
curl \
docker-ce \
wget \
tar \
gcc \
make \
zsh \
tmux \
docker \
mosh \
ca-certificates \
openssh-server \
php \
php-mysql \
php-xml \
php-openssl \
php-mysqli \
php-dom \
php-curl \
php-intl \
php-json \
php-tokenizer \
nodejs

# install neovim plugins
RUN pip3 install --upgrade pip setuptools && \
pip3 install neovim && \
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mkdir -p ~/.config/nvim/plugged

# install zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
RUN rm -f ~/.zshrc
RUN chsh -s $(which zsh)

# my dot files
RUN cd /root && git clone https://github.com/andre-karrlein/dot-ak1.git
RUN ln -s /root/dot-ak1/tmux.conf ~/.tmux.conf && ln -s /root/dot-ak1/zshrc ~/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN mv /root/dot-ak1/init.vim /root/.config/nvim/init.vim
RUN cd /root/dot/ak1 && bash coc-settings.sh

# create code dir
RUN mkdir /root/code
WORKDIR /root

#install go
RUN curl -s https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz| tar -v -C /usr/local -xz
ENV PATH $PATH:/usr/local/go/bin
RUN go get -v github.com/uudashr/gopkgs/cmd/gopkgs &&\
go get -v github.com/ramya-rao-a/go-outline &&\
go get -v github.com/acroca/go-symbols &&\
go get -v github.com/sqs/goreturns

RUN nvim --headless -c "PlugInstall! | qall! " && \
nvim --headless +UpdateRemotePlugins +qall

# install kubectl
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod 755 /usr/local/bin/kubectl

# install gcloud
RUN curl -sSL https://sdk.cloud.google.com | /bin/zsh
ENV PATH $PATH:/root/google-cloud-sdk/bin

# install docker compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN git config --global user.email "andre@karrlein.com"
RUN git config --global user.name "Andre Karrlein"

ENV TERM screen-256color
RUN mkdir /run/sshd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed 's/#Port 22/Port 3222/' -i /etc/ssh/sshd_config

EXPOSE 6001/udp 3222 8080 8099

ENTRYPOINT [ "/bin/zsh" ]
