Vagrant.configure(2) do |config|
  config.vm.box = "box-cutter/ubuntu1404-desktop"

  config.vm.network "forwarded_port", guest: 8080, host: 9088
  config.vm.network "forwarded_port", guest: 9083, host: 9083
  config.vm.network "forwarded_port", guest: 22, host: 9022
  config.vm.network "forwarded_port", guest: 9082, host: 9082
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8800, host: 8800
  config.vm.network "forwarded_port", guest: 1337, host: 1337

  config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = "agileworks-vm"
      vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo useradd -m user
    sudo usermod -aG sudo user
    sudo su -c  'echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
    sudo su -c  'echo "user:password" | chpasswd'
    apt-get -y -q update
    sudo apt-get -y install daemon unzip git build-essential sqlite3
    sudo su - user -c 'mkdir workspace'
  SHELL



  config.vm.provision "shell", inline: <<-SHELL
    # 安裝 node 請用完整版本號碼，使用 v5.12.0 而不是 v5

    sudo su - user -l -c 'wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash'
    sudo su - user -l -c '. ~/.nvm/nvm.sh && nvm install v5.12.0 && nvm alias default v5.12.0 && npm install pm2 -g'
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


    sudo su -c "env PATH=$PATH:/home/user/.nvm/versions/node/v5.12.0/bin pm2 startup -u user --hp /home/user"

  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    sudo su - user -l -c '. ~/.nvm/nvm.sh && cd workspace && git clone https://github.com/trunk-studio/electron-demo && cd electron-demo && npm i'
  SHELL


  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get clean
    sudo dpkg --clear-avail

  SHELL

  config.vm.synced_folder ".", "/vagrant", disabled: true
end
