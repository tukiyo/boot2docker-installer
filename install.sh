#------------------------------------------------------------------------
# CONFIG
NAMESERVER="8.8.8.8"
IPADDR="10.0.2.16/24"
ETH=eth0
GATEWAY="10.0.2.1"
DISK=sda
#------------------------------------------------------------------------

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
hostname boot2docker2
ip addr add $IPADDR dev $ETH
ip route add default via $GATEWAY
echo nameserver $NAMESERVER >> /etc/resolv.conf
echo 'TZ="JST-9"' > /etc/sysconfig/timezone
mount -o bind /var/lib/boot2docker/home /home/docker
mount -o bind /var/lib/boot2docker/root /root
mount -t tmpfs tmpfs /tmp
ulimit -n 65535
EOF
chmod +x $B2D/bootlocal.sh

## sshd
mkdir $B2D/ssh
cat > $B2D/ssh/sshd_config <<EOF
#UseDNS no
#Port 22
#PasswordAuthentication no
#PermitRootLogin no
#X11Forwarding yes
#X11DisplayOffset 10
EOF

## data folders
mkdir -p $B2D/home/.ssh $B2D/root/.ssh
chmod 600 $B2D/home/.ssh $B2D/root/.ssh
chown -R docker:staff $B2D/home
