# jenkins2-vagrant

Vagrant-box for testing Jenkins 2.0

Install

    brew cask install vagrant

Startup with

    vagrant up

Stop the vagrant machine

    vagrant halt

Use ssh into the vagrant machine

    vagrant ssh

Stop and delete the vagrant machine

    vagrant destory

Vagrant prints admin-password after environment is set up and Jenkins2 is accessible at [localhost:9088](http://localhost:9088/)

## how to build

```
vagrant up
make miniVM
```

移除 vm 之 box-disk1，掛載 box-disk2

```
make cleanVM
make exportVM
```

## check list

1. jenkins 新增 free stryle task 後是否可以選擇 git 作為建置來源
2. jenkins 新增 pipeline task 是否可以編輯 pipeline 區塊
