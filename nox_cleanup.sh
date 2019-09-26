# REQUIRES THAT YOU INSTALL SOME OTHER LAUNCHER FIRST!
# I prefer https://play.google.com/store/apps/details?id=com.jasonkung.launcher3
# If there's no launcher, you'll be left with empty screen and will have to install one through ADB.

# Run as root inside new instance of Nox to block its ad/tracking through /etc/hosts
# and remove its forced installation of Nox custom ad-packed launcher.

# sh /mnt/shared/Other/nox_cleanup.sh
# su -c /mnt/shared/Other/nox_cleanup.sh
mount -o rw,remount /system
echo 127.0.0.1 api.bignox.com >> /system/etc/hosts
echo 127.0.0.1 tracking.trnox.com >> /system/etc/hosts
echo 127.0.0.1 bi.yeshen.com >> /system/etc/hosts
echo 127.0.0.1 launcher.us.yeshen.com >> /system/etc/hosts
echo 127.0.0.1 pubstatus.sinaapp.com >> /system/etc/hosts
echo 127.0.0.1 noxagile.duapp.com >> /system/etc/hosts
echo 127.0.0.1 common.duapps.com >> /system/etc/hosts
echo 127.0.0.1 pasta.esfile.duapps.com >> /system/etc/hosts
echo 127.0.0.1 api.mobula.sdk.duapps.com >> /system/etc/hosts
echo 127.0.0.1 hmma.baidu.com >> /system/etc/hosts
echo 127.0.0.1 nrc.tapas.net >> /system/etc/hosts
echo 127.0.0.1 au.umeng.com >> /system/etc/hosts
echo 127.0.0.1 www.yeshen.com >> /system/etc/hosts
echo 127.0.0.1 www.yeshen.com.w.kunlungr.com >> /system/etc/hosts
echo 127.0.0.1 hm.e.shifen.com >> /system/etc/hosts
echo 127.0.0.1 tdcv3.talkingdata.net >> /system/etc/hosts
echo 127.0.0.1 alog.umeng.com >> /system/etc/hosts
echo 127.0.0.1 sdk.open.inc2.igexin.com >> /system/etc/hosts
echo 127.0.0.1 androiden.duapp.com >> /system/etc/hosts
awk '!seen[$0]++' /system/etc/hosts > /system/etc/hosts.uniq
mv /system/etc/hosts.uniq /system/etc/hosts
rm /system/app/launcher_*_signed.apk
rm /system/app/Launcher/launcher_*_signed.apk
chmod 0 /system/app/Launcher