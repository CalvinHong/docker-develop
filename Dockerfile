FROM centos:7

# Calvin Hong <calvin.hongbinfu@gmail.com>

USER root

# 系统升级
RUN yum upgrade -y && yum update -y

# 清除缓存
# RUN yum clean all

# 安装必备库
# RUN yum install -y centos-release-scl
# RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
# RUN yum install -y devtoolset-3
# # 激活devtoolset3
# RUN scl enable devtoolset-3 bash

RUN yum install -y \
    sudo \
    zsh \
    wget \
    git \
    curl \
	gcc gcc-c+ \
	automake autoconf libtool make \
	python-devel \
	ncurses-devel \
	pcre-devel \
	xz-devel \
	the_silver_searcher

# 设置zsh为默认shell
# 安装oh my zsh	
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"	
RUN chsh -s /bin/zsh && rm /bin/sh && ln -s /bin/zsh /bin/sh


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





# RUN echo 'export PATH=/usr/local/bin:$PATH' >> ~/.zshrc



#安装nvm
ENV NVM_DIR ~/.nvm
ENV NODE_VERSION stable
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | zsh
RUN cat $NVM_DIR/nvm.sh
#安装nodejs版本
RUN . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default
# NVM环境变量
#ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
#ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# 安装npm常用包
RUN npm install -g \
	pm2 \
	babel-core \
	webpack \
	nodemon
	

