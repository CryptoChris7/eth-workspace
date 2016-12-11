WORKSPACE=$HOME/workspace
if [ -d $WORKSPACE ]; then
    echo Workspace found at $WORKSPACE, exiting
    exit 1
fi

case $OSTYPE in
    linux*)
	if [ -z "$(which apt)" ]; then
	    echo 'Missing apt; exiting!'
	    exit 1
	fi
	GOPATH=$HOME/go
	curl -O https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.7.3.linux-amd64.tar.gz
	mkdir -p $GOPATH
	echo "export GOPATH=$GOPATH" >> $HOME/.bashrc
	echo "export PATH=\$PATH:$GOPATH/bin:/usr/local/go-1.7/bin" >> $HOME/.bashrc
	sudo apt update
	sudo apt -y install build-essential git emacs-nox python3-pip
	;;
    darwin*)
	xcode-select --install
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install python3 golang
	;;
    *)
	echo "Unknown OS, exiting"
	exit 1
	;;
esac

sudo pip3 install --upgrade pip
sudo pip3 install virtualenv
virtualenv $WORKSPACE
cd $WORKSPACE && . bin/activate

git clone https://github.com/ethereum/pyethereum.git
git clone https://github.com/ethereum/serpent.git
git clone https://github.com/ethereum/go-ethereum.git

cd $WORKSPACE/pyethereum && python setup.py install
cd $WORKSPACE/serpent && python setup.py install
cd $WORKSPACE/go-ethereum && make all
