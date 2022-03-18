#!/bin/bash
sudo apt install samba
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bkp


# é necessário configurar o disco com o comando FDISK
# "n" para criar uma nova partição

sudo /sbin/fdisk /dev/sdb
sudo /sbin/mkfs.ext4 /dev/sdb1
sudo mkdir /mnt/HD
sudo mount /dev/sdb1 /mnt/HD

sudo echo "[CompartilhamentoSamba]" >> /etc/samba/smb.conf
sudo echo "  comment = Samba no Debian" >> /etc/samba/smb.conf
sudo echo "  path = /mnt/HD" >> /etc/samba/smb.conf
sudo echo "  read only = no" >> /etc/samba/smb.conf
sudo echo "  browsable = yes" >> /etc/samba/smb.conf
sudo echo "  public = yes" >> /etc/samba/smb.conf

sudo /sbin/service smbd restart

quem=$(whoami)
sudo smbpasswd -a $quem

sudo chmod -R 777 /mnt/HD

sudo echo "#!/bin/sh" > /etc/rc.local
sudo echo "sleep 4" >>/etc/rc.local
sudo echo "mount /dev/sdb1 /mnt/HD" >>/etc/rc.local
sudo echo "chmod -R 777 /mnt/HD" >>/etc/rc.local
sudo echo "exit 0" >> /etc/rc.local

sudo chmod +x /etc/rc.local


