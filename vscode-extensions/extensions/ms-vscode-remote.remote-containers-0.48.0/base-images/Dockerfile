FROM ubuntu:18.04

RUN apt-get update \
	&& apt-get install -y \
		curl \
		git \
		zsh \
	&& rm -rf /var/lib/apt/lists/*

SHELL ["/bin/zsh", "-c"]
ENV SHELL /bin/zsh
RUN chsh -s /bin/zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN sed -ie 's/^plugins=(/\0zsh-autosuggestions /' ~/.zshrc

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshenv
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshenv
RUN nvm install 10.15.1
RUN npm install -g yarn eslint

# docker build -t chrmarti/node base-images
# docker push chrmarti/node