# REQUIRES THAT YOU INSTALL SOME OTHER LAUNCHER FIRST!
# I prefer https://play.google.com/store/apps/details?id=com.jasonkung.launcher3
# If there's no launcher, you'll be left with empty screen and will have to install one through ADB.

# Put it into %USERPROFILE%\Nox_share\Other and %USERPROFILE%\Nox_share\OtherShare.

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
echo 127.0.0.1 attitude.applinzi.com >> /system/etc/hosts
echo 127.0.0.1 launcher-us.yeshen.com >> /system/etc/hosts
echo 127.0.0.1 tracking.apptrackerlink.com >> /system/etc/hosts
echo 127.0.0.1 res.noxmobi.com >> /system/etc/hosts
echo 127.0.0.1 res09.bignox.com >> /system/etc/hosts
echo 127.0.0.1 noxagile.bceapp.com >> /system/etc/hosts
echo 127.0.0.1 bignox.com >> /system/etc/hosts
echo 127.0.0.1 8.bignox.com >> /system/etc/hosts
echo 127.0.0.1 id.bignox.com >> /system/etc/hosts
echo 127.0.0.1 res02.bignox.com >> /system/etc/hosts
echo 127.0.0.1 res.bignox.com >> /system/etc/hosts
echo 127.0.0.1 passport-us.bignox.com >> /system/etc/hosts
echo 127.0.0.1 passport.bignox.com >> /system/etc/hosts
echo 127.0.0.1 res05.bignox.com >> /system/etc/hosts
echo 127.0.0.1 bbs.bignox.com >> /system/etc/hosts
echo 127.0.0.1 ru.bignox.com >> /system/etc/hosts
echo 127.0.0.1 t.bignox.com >> /system/etc/hosts
echo 127.0.0.1 cn.bignox.com >> /system/etc/hosts
echo 127.0.0.1 phone.bignox.com >> /system/etc/hosts
echo 127.0.0.1 de.bignox.com >> /system/etc/hosts
echo 127.0.0.1 sj.bignox.com >> /system/etc/hosts
echo 127.0.0.1 st.bignox.com >> /system/etc/hosts
echo 127.0.0.1 log.bignox.com >> /system/etc/hosts
echo 127.0.0.1 gift.bignox.com >> /system/etc/hosts
echo 127.0.0.1 vip.bignox.com >> /system/etc/hosts
echo 127.0.0.1 unauthorized.bignox.com >> /system/etc/hosts
echo 127.0.0.1 tw.bignox.com >> /system/etc/hosts
echo 127.0.0.1 pt.bignox.com >> /system/etc/hosts
echo 127.0.0.1 www.bignox.com >> /system/etc/hosts
echo 127.0.0.1 es.bignox.com >> /system/etc/hosts
echo 127.0.0.1 android.bignox.com >> /system/etc/hosts
echo 127.0.0.1 app.bignox.com >> /system/etc/hosts
echo 127.0.0.1 sns.bignox.com >> /system/etc/hosts
echo 127.0.0.1 tui.bignox.com >> /system/etc/hosts
echo 127.0.0.1 my.bignox.com >> /system/etc/hosts
echo 127.0.0.1 fr.bignox.com >> /system/etc/hosts
echo 127.0.0.1 wap.bignox.com >> /system/etc/hosts
echo 127.0.0.1 group.bignox.com >> /system/etc/hosts
echo 127.0.0.1 ms.bignox.com >> /system/etc/hosts
echo 127.0.0.1 download.bignox.com >> /system/etc/hosts
echo 127.0.0.1 mis.bignox.com >> /system/etc/hosts
echo 127.0.0.1 res12.bignox.com >> /system/etc/hosts
echo 127.0.0.1 union.bignox.com >> /system/etc/hosts
echo 127.0.0.1 sdk.bignox.com >> /system/etc/hosts
echo 127.0.0.1 app.test.bignox.com >> /system/etc/hosts
echo 127.0.0.1 survey.bignox.com >> /system/etc/hosts
echo 127.0.0.1 plat-api.bignox.com >> /system/etc/hosts
echo 127.0.0.1 app.static.bignox.com >> /system/etc/hosts
echo 127.0.0.1 ph.bignox.com >> /system/etc/hosts
echo 127.0.0.1 res11.bignox.com >> /system/etc/hosts
echo 127.0.0.1 gray.bignox.com >> /system/etc/hosts
echo 127.0.0.1 game.bignox.com >> /system/etc/hosts
echo 127.0.0.1 user.bignox.com >> /system/etc/hosts
echo 127.0.0.1 kr.bignox.com >> /system/etc/hosts
echo 127.0.0.1 tl.bignox.com >> /system/etc/hosts
echo 127.0.0.1 tv.bignox.com >> /system/etc/hosts
echo 127.0.0.1 dev.bignox.com >> /system/etc/hosts
echo 127.0.0.1 news.bignox.com >> /system/etc/hosts
echo 127.0.0.1 res06.bignox.com >> /system/etc/hosts
echo 127.0.0.1 api-new.bignox.com >> /system/etc/hosts
echo 127.0.0.1 info.bignox.com >> /system/etc/hosts
echo 127.0.0.1 mobile.bignox.com >> /system/etc/hosts
echo 127.0.0.1 en.bignox.com >> /system/etc/hosts
echo 127.0.0.1 player.bignox.com >> /system/etc/hosts
echo 127.0.0.1 feed.bignox.com >> /system/etc/hosts
echo 127.0.0.1 mail.bignox.com >> /system/etc/hosts
echo 127.0.0.1 shouyou.bignox.com >> /system/etc/hosts
echo 127.0.0.1 pop3.bignox.com >> /system/etc/hosts
echo 127.0.0.1 ios.bignox.com >> /system/etc/hosts
echo 127.0.0.1 image.bignox.com >> /system/etc/hosts
echo 127.0.0.1 open.bignox.com >> /system/etc/hosts
echo 127.0.0.1 pay.bignox.com >> /system/etc/hosts
awk '!seen[$0]++' /system/etc/hosts > /system/etc/hosts.uniq
mv /system/etc/hosts.uniq /system/etc/hosts
rm /system/app/launcher_*_signed.apk
rm /system/app/Launcher/launcher_*_signed.apk
chmod 0 /system/app/Launcher