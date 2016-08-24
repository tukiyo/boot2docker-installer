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
PERSIST=/mnt/sda2/var/lib/boot2docker
mkdir -p $PERSIST
mount /dev/sda2 $PERSIST

#-----------------------------------
# profile
#-----------------------------------
cat > $PERSIST/profile <<EOF
ulimit -n 65535
EOF

#-----------------------------------
# bootlocal.sh
#-----------------------------------
cat > $PERSIST/bootlocal.sh <<EOF
export TZ="JST-9"
EOF
