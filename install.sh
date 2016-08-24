## install
dd if=/dev/sr0 of=/dev/sda bs=1M
/usr/local/sbin/partprobe /dev/sda

## create
fdisk /dev/sda <<EOF
n
p
2



w
EOF
mkfs.ext4 -L boot2docker-data /dev/sda2

## mount
mount /dev/sda2 /mnt/sda2 || (sleep 5; mount /dev/sda2 /mnt/sda2)

B2D=/mnt/sda2/var/lib/boot2docker
mkdir -p $B2D

cat > $B2D/profile <<EOF
ulimit -n 65535
EOF

cat > $B2D/bootlocal.sh <<EOF
hostname boot2docker2
echo JST-9 > /etc/localtime
EOF
chmod +x $B2D/bootlocal.sh
