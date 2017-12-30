FROM ubuntu:16.04

# Calvin Hong <calvin.hongbinfu@gmail.com>

USER root

# 系统升级
RUN apt upgrade -y && apt update -y

# 清除缓存
# RUN yum clean all

# 安装必备库
# RUN yum install -y centos-release-scl
# RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
# RUN yum install -y devtoolset-3
# # 激活devtoolset3
# RUN scl enable devtoolset-3 bash

RUN apt install -y \
    sudo \
    zsh \
    wget \
    git \
    curl \
    which \
    gcc gcc-c+ \
    automake autoconf libtool make \
    python-devel \
    ncurses-devel \
    pcre-devel \
    xz-devel \
    the_silver_searcher
	
# 设置zsh为默认shell	
ENV SHELL /bin/zsh
RUN chsh -s /bin/zsh

# 安装oh my zsh	
RUN zsh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


# 更新vim
RUN cd /usr/local/src && \
	git clone https://github.com/vim/vim.git && \
	cd vim && \
	./configure \
	--with-features=huge \
	#打开对ruby编写的插件的支持
	–enable-rubyinterp \
	# 打开对python编写的插件的支持
	–enable-pythoninterp \
	# 打开对lua编写的插件的支持
	–enable-luainterp \
	# 打开对perl编写的插件的支持
	–enable-perlinterp \
	# 打开多字节支持，可以在Vim中输入中文
	–enable-multibyte \
	# 打开对cscope的支持
	–enable-cscope \
	# python配置目录
	--with-python-config-dir=/usr/lib64/python2.7/config && \
	make && \
	make install

# 设置vim配置	
RUN cd ~ && \
    git clone https://github.com/CalvinHong/vim.git .vim && \
	cd .vim && \
	./install.sh

#安装node.js
RUN curl --silent --location https://rpm.nodesource.com/setup_9.x | bash -
RUN zsh -c 'apt install -y nodejs && \
    source ~/.zshrc && \
    npm install -g \
	pm2 \
	webpack \
	nodemon'
