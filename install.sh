#!/bin/sh
set -eu

# CONFIG----------------------------------------------------------------
HOSTNAME="b2d"
#IPADDR="10.0.2.16/24"
#GATEWAY="10.0.2.1"
#ETH=eth0
DISK=sda
#-----------------------------------------------------------------------
#GITHUB_USER="tukiyo"
if [ $# -eq 1 ];then
    GITHUB_USER=$1
else
    echo "To wget https://github.com/Username.keys ,"
    echo -n "enter GitHub's Username : "
    read GITHUB_USER
fi

## install
dd if=/dev/sr0 of=/dev/${DISK} bs=1M
/usr/local/sbin/partprobe /dev/${DISK}

## create
(echo n; echo p; echo 2; echo; echo; echo w) | fdisk /dev/${DISK}
mkfs.ext4 -L boot2docker-data /dev/${DISK}2

## mount
mount /dev/${DISK}2 /mnt/${DISK}2 || (sleep 5; mount /dev/${DISK}2 /mnt/${DISK}2)
B2D=/mnt/${DISK}2/var/lib/boot2docker
mkdir -p $B2D

## startup script
cat > $B2D/bootlocal.sh <<EOF
#!/bin/sh
set -x
hostname $HOSTNAME
echo 'TZ="JST-9"' > /etc/sysconfig/timezone
mount -o bind /var/lib/boot2docker/home /home/docker
mount -o bind /var/lib/boot2docker/root /root
mount -t tmpfs tmpfs /mnt/sda2/tmp
if [ -e $B2D/network.sh ];then
    sh $B2D/network.sh
fi
EOF
chmod +x $B2D/bootlocal.sh

## network settings.
#cat > $B2D/network.sh <<EOF
#ip addr add $IPADDR dev $ETH
#ip route add default via $GATEWAY
#EOF

## template file.
## see: /etc/init.d/docker
cat > $B2D/profile <<EOF
#DOCKER_HOST='-H tcp://0.0.0.0:2375'
EOF

## sshd
mkdir $B2D/ssh
cat > $B2D/ssh/sshd_config <<EOF
UseDNS no
Port 22
PasswordAuthentication no
PermitRootLogin no
EOF

## data folders
mkdir -p $B2D/home/.ssh $B2D/root/.ssh
wget https://github.com/$GITHUB_USER.keys -O $B2D/root/.ssh/authorized_keys
cp $B2D/root/.ssh/authorized_keys $B2D/home/.ssh/
chmod 600 $B2D/home/.ssh $B2D/root/.ssh
chown -R docker:staff $B2D/home


## done
echo "install finished. please reboot."
