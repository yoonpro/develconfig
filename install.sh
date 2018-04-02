#!/bin/sh

if [ $# -eq 0 ]; then
DIR=`pwd`
if [[ "$DIR" == *develconfig ]]
then
    cd ..
    DIR=`pwd`
fi
else
DIR=$1
fi

export HOME=$DIR
cd $HOME
ID=`echo ${PWD##*/}`

cp -fp develconfig/myrc develconfig/myrc_local
cp -fp develconfig/gitconfig develconfig/gitconfig_local
sed -i "s|HOME_PASS_HERE|$DIR|g" develconfig/myrc_local
sed -i "s/ID_HERE/$ID/g" develconfig/myrc_local
sed -i "s/ID_HERE/$ID/g" develconfig/gitconfig_local

echo "디렉토리 생성..."
mkdir -p $HOME/.zsh

echo "심볼릭 릭크 생성..."
ln -sfv ~/develconfig/tmux.conf ~/.tmux.conf
ln -sfv ~/develconfig/screenrc ~/.screenrc
ln -sfv ~/develconfig/zshrc ~/.zshrc
ln -sfv ~/develconfig/vimrc ~/.vimrc
ln -sfv ~/develconfig/myrc_local ~/rundevel
ln -sfv ~/develconfig/gitconfig_local ~/.gitconfig
ln -sfv ~/develconfig/gitignore_global ~/.gitignore_global

if [ ! -f /etc/zshrc ]; then
	cp -fp ~/develconfig/etc_zshrc /etc/zshrc
fi

if [ -e ~/.vim ]; then
	echo "경고: 설치를 진행하려면 ~/.vim/ 디렉토리를 삭제해야 합니다."
	exit
fi

if [ ! -f /usr/local/bin/vim ]; then
	echo "vim 7.4를 설치 합니다."
	yum install -y ncurses-devel
	#wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
    wget ftp://ftp.vim.org/pub/vim/unix/vim-8.0.tar.bz2
	#tar xvfj vim-7.4.tar.bz2
	tar xvfj vim-8.0.tar.bz2
	#cd vim74
	cd vim80
	./configure --with-features=huge --disable-gui --without-x --enable-rubyinterp --enable-cscope --enable-multibyte --enable-hangulinput
	make
	make install
	cd $HOME
fi

export GIT_SSL_NO_VERIFY=true
echo "vundle 다운로드중..."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "vundle 설치중..."
/usr/local/bin/vim -c :BundleInstall -c :qa

echo "syntax 설치중..."
cp -fpR ~/develconfig/syntax ~/.vim/.

