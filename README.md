# boot2dockerをvirtualboxへインストール

## 特徴

* boot2docker.isoをHDDにインストール、パーティショニング
* ssh公開鍵をGitHubからダウンロード
* /home/docker/, /root/ を永続化


## インストール

1. boot2docker.iso でboot

```
git clone https://github.com/tukiyo/boot2docker-installer
cd boot2docker-installer
#vi install.sh
sh install.sh
```

## ファイル

|ファイル|説明|
|:--|:--|
| /mnt/sda2/var/lib/boot2docker/bootlocal.sh | スタートアップスクリプト |
| /mnt/sda2/var/lib/boot2docker/network.sh | IP設定用 |
| /mnt/sda2/var/lib/boot2docker/profile | docker起動時の設定 |
| /mnt/sda2/var/lib/boot2docker/root | /root |
| /mnt/sda2/var/lib/boot2docker/home | /home/docker |
| /mnt/sda2/var/lib/boot2docker/ssh/sshd_config | sshd_config |
