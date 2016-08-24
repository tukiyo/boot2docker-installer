#-----------------------------------
# mount
#-----------------------------------
mount /dev/sda2 /mnt/sda2
B2D=/mnt/sda2/tmp
mkdir -p $B2D

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
