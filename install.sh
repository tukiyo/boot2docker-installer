dd if=/dev/sr0 of=/dev/sda bs=1M
/usr/local/sbin/partprobe

fdisk /dev/sda <<EOF
n
p
2



w
EOF

mkfs.ext4 -L boot2docker-data /dev/sda2
export TZ="JST-9"
