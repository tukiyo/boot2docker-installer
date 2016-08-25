## install
dd if=/dev/sr0 of=/dev/sda bs=1M
/usr/local/sbin/partprobe /dev/sda

## create
(echo n; echo p; echo 2; echo; echo; echo; echo w) | fdisk /dev/sda
mkfs.ext4 -L boot2docker-data /dev/sda2

## mount
mount /dev/sda2 /mnt/sda2 || (sleep 5; mount /dev/sda2 /mnt/sda2)
B2D=/mnt/sda2/var/lib/boot2docker
mkdir -p $B2D

## profile
cat > $B2D/profile <<EOF
ulimit -n 65535
EOF

## startup script
cat > $B2D/bootlocal.sh <<EOF
hostname boot2docker2
ip addr add 10.0.2.16/24 dev eth0
ip route add default via 10.0.2.1
echo nameserver 8.8.8.8 >> /etc/resolv.conf
echo 'TZ="JST-9"' > /etc/sysconfig/timezone
mount -o bind /var/lib/boot2docker/home /home/docker
mount -o bind /var/lib/boot2docker/root /root
EOF
chmod +x $B2D/bootlocal.sh

## sshd
mkdir $B2D/ssh
cat > $B2D/ssh/sshd_config <<EOF
#UseDNS no
#Port 22
#PasswordAuthentication no
#PermitRootLogin no
EOF

## data folders
mkdir -p $B2D/home/.ssh $B2D/root/.ssh
chmod 600 $B2D/home/.ssh $B2D/root/.ssh
chown -R docker:staff $B2D/home
