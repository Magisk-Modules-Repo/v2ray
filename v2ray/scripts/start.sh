#!/system/bin/sh

MODDIR=${0%/*}

start_proxy () {
  ${MODDIR}/v2ray.service start &> /data/v2ray/run/service.log && \
  if [ -f /data/v2ray/appid.list ] || [ -f /data/v2ray/softap.list ] ; then
    ${MODDIR}/v2ray.tproxy enable &>> /data/v2ray/run/service.log && \
    ${MODDIR}/v2ray-dns.service start &>> /data/v2ray/run/service.log &
  fi
}
if [ ! -f /data/v2ray/manual ] ; then
  start_proxy
fi
inotifyd ${MODDIR}/v2ray.inotify ${MODDIR}/.. &>> /data/v2ray/run/service.log &
