#!/sbin/sh
#####################
# V2ray Customization
#####################
SKIPUNZIP=1

# prepare v2ray execute environment
ui_print "- Prepare V2Ray execute environment."
mkdir -p /data/v2ray
mkdir -p /data/v2ray/dnscrypt-proxy
mkdir -p /data/v2ray/run
mkdir -p $MODPATH/scripts
mkdir -p $MODPATH/system/bin
mkdir -p $MODPATH/system/app
mkdir -p $MODPATH/system/app/Stk
mkdir -p $MODPATH/system/etc

ui_print "- Install V2Ray core execute files"
unzip -j -o "${ZIPFILE}" "v2ray/bin/v2ray" -d $MODPATH/system/bin >&2
unzip -j -o "${ZIPFILE}" "v2ray/bin/geoip.dat" -d /data/v2ray >&2
unzip -j -o "${ZIPFILE}" "v2ray/bin/geosite.dat" -d /data/v2ray >&2
unzip -j -o "${ZIPFILE}" "v2ray/bin/v2manager.apk" -d $MODPATH/system/app/Stk >&2
unzip -j -o "${ZIPFILE}" 'v2ray/scripts/*' -d $MODPATH/scripts >&2
unzip -j -o "${ZIPFILE}" 'service.sh' -d $MODPATH >&2
unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d $MODPATH >&2

# pm command was not working in install scipt?
ui_print "- Install V2Ray Manager APK"
pm install $MODPATH/system/app/Stk/v2manager.apk

rm "${download_v2ray_zip}"
# copy v2ray data and config
ui_print "- Copy V2Ray config and data files"
[ -f /data/v2ray/softap.list ] || \
echo "192.168.43.0/24" > /data/v2ray/softap.list
[ -f /data/v2ray/resolv.conf ] || \
unzip -j -o "${ZIPFILE}" "v2ray/etc/resolv.conf" -d /data/v2ray >&2
unzip -j -o "${ZIPFILE}" "v2ray/etc/config.json.template" -d /data/v2ray >&2
[ -f /data/v2ray/config.json ] || \
cp /data/v2ray/config.json.template /data/v2ray/config.json
ln -s /data/v2ray/resolv.conf $MODPATH/system/etc/resolv.conf
# generate module.prop
ui_print "- Generate module.prop"
rm -rf $MODPATH/module.prop
touch $MODPATH/module.prop
echo "id=v2ray" > $MODPATH/module.prop
echo "name=V2ray for Android" >> $MODPATH/module.prop
echo "version=4.44.0" >> $MODPATH/module.prop
echo "versionCode=20210801" >> $MODPATH/module.prop
echo "author=ohnoku" >> $MODPATH/module.prop
echo "description=V2ray core with service scripts for Android" >> $MODPATH/module.prop

inet_uid="3003"
net_raw_uid="3004"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm  $MODPATH/service.sh    0  0  0755
set_perm  $MODPATH/uninstall.sh    0  0  0755
set_perm  $MODPATH/scripts/start.sh    0  0  0755
set_perm  $MODPATH/scripts/v2ray.service    0  0  0755
set_perm  $MODPATH/scripts/v2ray.tproxy     0  0  0755
set_perm  $MODPATH/system/bin/v2ray  ${inet_uid}  ${inet_uid}  0755
set_perm  /data/v2ray                ${inet_uid}  ${inet_uid}  0755
