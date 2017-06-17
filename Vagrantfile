Vagrant.configure(2) do |config|
  config.vm.box = "box-cutter/ubuntu1604-desktop"

  config.vm.network "forwarded_port", guest: 8080, host: 9088
  config.vm.network "forwarded_port", guest: 9083, host: 9083
  config.vm.network "forwarded_port", guest: 22, host: 9022
  config.vm.network "forwarded_port", guest: 9082, host: 9082
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8800, host: 8800
  config.vm.network "forwarded_port", guest: 1337, host: 1337

  config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = "agileworks-vm-desktop"
      vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo useradd -m user
    sudo usermod -aG sudo user
    sudo su -c  'echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
    sudo su -c  'echo "user:password" | chpasswd'
    sudo add-apt-repository -y ppa:openjdk-r/ppa
    sudo apt-add-repository -y ppa:andrei-pozolotin/maven3
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get -y -q update
    
    sudo apt-get -y purge openjdk-7-jdk default-jre default-jdk firefox
    sudo apt-get -y -q install software-properties-common htop
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    sudo apt-get -y -q install oracle-java8-installer
    sudo update-java-alternatives -s java-8-oracle

    sudo apt-get -y install daemon unzip git build-essential sqlite3

    # fix terminal can not open
    sudo locale-gen
    sudo localectl set-locale LANG="en_US.UTF-8"
    sudo su - user -c 'mkdir workspace'

    # install chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
    sudo apt-get install -f -y
  SHELL



  config.vm.provision "shell", inline: <<-SHELL
    # 安裝 node 請用完整版本號碼，使用 v6.9.5 而不是 v6

    sudo su - user -l -c 'wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash'
    sudo su - user -l -c '. ~/.nvm/nvm.sh && nvm install v6.9.5 && nvm alias default v6.9.5 && npm install pm2 webdriver-manager -g && webdriver-manager update'
  SHELL


  config.vm.provision "shell", inline: <<-SHELL

    sudo su - user -l -c 'wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash'
    sudo su - user -l -c '. ~/.nvm/nvm.sh && pm2 set pm2-webshell:port 9082 && pm2 install pm2-webshell'

    sudo su - user -l -c 'git clone https://github.com/agileworks-tw/pm2-webshell.git'
    sudo su - user -l -c 'cp -r pm2-webshell/node_modules/tty.js/static/ .pm2/node_modules/pm2-webshell/node_modules/tty.js/'
    sudo su - user -l -c 'cp -r pm2-webshell/app.js .pm2/node_modules/pm2-webshell/app.js && rm -rf pm2-webshell'
    sudo su - user -l -c '. ~/.nvm/nvm.sh && pm2 restart pm2-webshell'

    sudo su - user -l -c '. ~/.nvm/nvm.sh && git clone git://github.com/c9/core.git c9sdk && cd c9sdk && scripts/install-sdk.sh'

    # ref: https://gist.github.com/RIAEvangelist/6335743#gistcomment-1839910
    sudo su - user -l -c '. ~/.nvm/nvm.sh && cd c9sdk && rm -rf node_modules/pty.js && ~/.c9/node/bin/npm install pty.js'


    sudo su - user -l -c '. ~/.nvm/nvm.sh && cd c9sdk && pm2 start server.js --name "cloud9" -- --debug -l 0.0.0.0 -p 9083 -w /home/user/workspace -a :'


    sudo su -c "env PATH=$PATH:/home/user/.nvm/versions/node/v6.9.5/bin pm2 startup -u user --hp /home/user"

  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    sudo su - user -l -c '. ~/.nvm/nvm.sh && cd workspace && git clone https://github.com/alincode/webdriverio-pageobject.git && cd webdriverio-pageobject && npm i'
  SHELL


  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get clean
    sudo dpkg --clear-avail

  SHELL

  config.vm.synced_folder ".", "/vagrant", disabled: true
end
