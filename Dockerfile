FROM centos:7

# Calvin Hong <calvin.hongbinfu@gmail.com>

USER root

RUN yum -y install wget

#备份源
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

RUN cd /etc/yum.repos.d/

# 使用163源
RUN wget http://mirrors.163.com/.help/CentOS7-Base-163.repo

# 清除缓存
RUN yum clean all

# 系统升级
RUN yum upgrade && yum update

# 安装必备库
RUN yum -y install \
    git \
    zsh \
    curl \
	centos-release-scl \
	devtoolset-3-toolchain \
	gcc-c++ \
	python-devel \
	ncurses-devel \
	pcre-devel \
	xz-devel \
	automake \
	the_silver_searcher

# 激活devtoolset3
RUN scl enable devtoolset-3 bash


# 更新vim
RUN yum remove vim-* -y && \
    cd /usr/local/src && \
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
	sudo make install

# 设置vim配置	
RUN cd ~ && \
    git clone https://github.com/CalvinHong/vim.git .vim && \
	cd .vim && \
	./install.sh



# 设置zsh为默认shell
RUN chsh -s /bin/zsh

# RUN echo 'export PATH=/usr/local/bin:$PATH' >> ~/.zshrc

# 安装oh my zsh	
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"	


RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

#安装nvm
ENV NODE_VERSION 9.3.0

#install the specified node version and set it as the default one, install the global npm packages
RUN nvm install $NODE_VERSION && \
	nvm alias default $NODE_VERSION && \
	npm install -g \
	pm2 \
	babel-core \
	webpack \
	nodemon

