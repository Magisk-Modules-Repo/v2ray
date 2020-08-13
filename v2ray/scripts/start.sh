#!/system/bin/sh

MODDIR=${0%/*}

start_proxy () {
  ${MODDIR}/v2ray.service start &> /data/v2ray/run/service.log && \
  if [ -f /data/v2ray/appid.list ] || [ -f /data/v2ray/softap.list ] ; then
    ${MODDIR}/v2ray.tproxy enable &>> /data/v2ray/run/service.log && \
    if [ -f /data/v2ray/dns2socks.conf ] ; then
      ${MODDIR}/dns2socks.service start &>> /data/v2ray/run/service.log &
    fi
  fi
}
if [ ! -f /data/v2ray/manual ] ; then
  start_proxy
  inotifyd ${MODDIR}/v2ray.inotify ${MODDIR}/.. &>> /data/v2ray/run/service.log &
fi
