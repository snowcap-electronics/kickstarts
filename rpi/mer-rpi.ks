#
# Kickstart for Raspberry Pi
#

lang en_US.UTF-8
keyboard us
timezone --utc UTC
part /boot --size 50 --ondisk mmcblk0p --fstype=vfat
part / --size 1500 --ondisk mmcblk0p --fstype=ext4
rootpw rootme 

user --name mer  --groups audio,video --password rootme 

repo --name=mer-core --baseurl=http://releases.merproject.org/releases/latest/builds/armv6l/packages --save --debuginfo --source
repo --name=rpi-ha --baseurl=http://repo.pub.meego.com//home:/kulve:/rpi-ha/Mer_Core_armv6l/ --save --debuginfo --source
%packages

@Mer Connectivity
@Mer Graphics Common
@Mer Minimal Xorg
@Mer Core


qt-qmlviewer
xorg-x11-drv-evdev
xorg-x11-drv-vesa
xorg-x11-drv-fbdev
xorg-x11-server-Xorg-setuid
-xorg-x11-server-Xorg

openssh
openssh-clients
openssh-server


@Raspberry Pi Boot

%end

%post
# Create a session file for qmlviewer.
cat > /usr/share/xsessions/X-MER-QMLVIEWER.desktop << EOF
[Desktop Entry]
Version=1.0
Name=qmlviewer
Exec=/usr/bin/qmlviewer
Type=Application
EOF

# Set symlink pointing to .desktop file 
ln -sf X-MER-QMLVIEWER.desktop /usr/share/xsessions/default.desktop

# Rebuild db using target's rpm
echo -n "Rebuilding db using target rpm.."
rm -f /var/lib/rpm/__db*
rpm --rebuilddb
echo "done"

# Prelink can reduce boot time
if [ -x /usr/sbin/prelink ]; then
   echo -n "Running prelink.."
   /usr/sbin/prelink -aRqm
   echo "done"
fi




%end

%post --nochroot

%end
