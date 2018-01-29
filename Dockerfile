FROM ubuntu:16.04

# Calvin Hong <calvin.hongbinfu@gmail.com>

USER root

# 系统升级
RUN apt upgrade -y && \
  apt update -y && \
  apt install -y software-properties-common && \
# 添加vim最新源  
  add-apt-repository -y ppa:jonathonf/vim && \
  apt update -y

# 安装必要库
RUN apt install -y \
    wget \
    zsh \
    git \
    curl \
    tree \
    lsof \
    silversearcher-ag \ 
    ctags \
# vim python2支持    
    vim-nox-py2 \
# YouCompeleMe 需要
    build-essential \
    cmake \
    python-dev
	
# 设置zsh为默认shell	
ENV SHELL /bin/zsh
RUN chsh -s /bin/zsh

# 安装oh my zsh	
RUN zsh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# 默认配置
# 开启256颜色支持
RUN echo 'export TERM=xterm-256color' >> ~/.zshrc

# 设置vim配置	
RUN cd ~ && \
    git clone https://github.com/CalvinHong/vim.git .vim && \
	cd .vim && \
	./install.sh && \
	vim +PlugInstall +qall

#安装node.js
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN zsh -c 'apt install -y nodejs && \
    source ~/.zshrc && \
    npm install -g \
	pm2 \
	webpack \
	webpack-dev-server'

#设置区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#powerline
RUN cd ~/ && \
git clone https://github.com/powerline/fonts.git --depth=1 && \
cd fonts && \
./install.sh && \
# clean-up a bit
cd ../ && \
rm -rf fonts
