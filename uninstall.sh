##########################################################################################
#
# V2Ray Magisk Module Uninstaller Script
#
##########################################################################################

uninstall_manager_apk() {
  pm uninstall co.lintian.v2manager
}

remove_v2ray_data_dir() {
  rm -rf /data/v2ray
}

# remove v2ray data
remove_v2ray_data_dir

# uninstall manager apk
uninstall_manager_apk
