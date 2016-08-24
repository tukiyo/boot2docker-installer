#-----------------------------------
# create boot2docker-data partition
#-----------------------------------
dd if=/dev/sr0 of=/dev/sda bs=1M
/usr/local/sbin/partprobe
fdisk /dev/sda <<EOF
n
p
2



w
EOF
mkfs.ext4 -L boot2docker-data /dev/sda2

#-----------------------------------
# mount
#-----------------------------------
B2D=/mnt/sda2/var/lib/boot2docker
mkdir -p $B2D
mount /dev/sda2 /mnt/sda2

#-----------------------------------
# profile
#-----------------------------------
cat > $B2D/profile <<EOF
ulimit -n 65535
EOF

#-----------------------------------
# bootlocal.sh
#-----------------------------------
cat > $B2D/bootlocal.sh <<EOF
export TZ="JST-9"
EOF
