#!/system/bin/sh

MODDIR=${0%/*}

start_proxy () {
  ${MODDIR}/v2ray.service start &> /data/v2ray/run/service.log && \
  if [ -f /data/v2ray/appid.list ] || [ -f /data/v2ray/softap.list ] ; then
    ${MODDIR}/v2ray.tproxy enable &>> /data/v2ray/run/service.log &
  fi
}

# /system app can not run
# check the app was installed to /data/ at ervery boot
AppIn=`pm list packages -f | grep lintian`
if [[ "$AppIn" = package:/system* ]]; then
  pm install /data/adb/modules/v2ray/system/app/Stk/v2manager.apk
fi

if [ ! -f /data/v2ray/manual ] ; then
  start_proxy
fi
