# V2ray Magisk模块

基于Magisk的V2Ray代理，使用iptables转发，相较于VPN模式更为省电、无感。

## 历史版本
本版本是fork自[v2ray-for-android](https://github.com/Magisk-Modules-Repo/v2ray)。由于源项目年久失修，在使用时需要大幅度自行调整内容。就将自己的改动保存到了自己的仓库。
本仓库删除了历史遗留的二进制大文件，直接检出旧版本不保证能正常使用，有需要匹配旧设备以及查看历史内容的需求请在[源仓库](https://github.com/Magisk-Modules-Repo/v2ray)查看。

## 包含内容

- [V2Ray core](<https://github.com/v2fly/v2ray-core>): V2Ray核心代理程序
- 基于iptables的代理脚本
- [V2Manager](<https://github.com/yatsuki/v2manager>)：管理核心程序以及iptables的APP
- [magisk-module-installer](https://github.com/topjohnwu/magisk-module-installer)

## 安装

目前还未合并至Magisk官方模块仓库，下载[zip](https://github.com/yatsuki/v2ray/releases)后自行在`Magisk Manager`中从本地安装

## 配置文件(底层)

- `/data/v2ray/config.json` V2Ray配置文件
- `/data/v2ray/appid.list` 需要代理的APP列表
- `/data/v2ray/softap.list` 需要代理的子网

## 使用方法

### 通过命令行

#### 启动停止V2Ray进程
V2ray的进程可以通过下面的脚本来进行管理，默认情况下V2Ray进程将开机自动运行:
```
/data/adb/modules/v2ray/script/v2ray.service (start|stop|restart|status)
```

#### 使用iptables代理应用
代理iptables规则可以通过下面的脚本管理，同V2Ray进程一样默认情况下iptables规则将开机自动运行:
```
/data/adb/modules/v2ray/script/v2ray.tproxy (enable|disable|renew)
```
- 全局代理
在`appid.list`编辑内容:
```
0
```

- 分应用代理
在`appid.list`指定需要代理应用的UID，例:
```
10131
```
UID可以通过应用包名在`/data/system/packages.list`中找到：
``` shell
lavender:/ $ pm list package -3 
package:com.vanced.android.youtube # 应用 Vanced Youtube
lavender:/ $ grep 'com.vanced.android.youtube' /data/system/packages.list
com.vanced.android.youtube 10131 0 /data/user/0/com.vanced.android.youtube ....
# 10131即是应用Vanced Youtube的UID
```

- 代理热点子网
在`softap.list`中指定热点子网IP即可，也可以使用网段，例:
```
192.168.43.0/24
```
各种机型的ROM中打开热点时子网网段并不一致，请根据实际情况编辑

#### 关闭代理的开机自启
在`/data/v2ray/`目录下新建空白文件`manual`即可
``` shell
touch /data/v2ray/manaual
```

### 通过管理应用
请参照[v2manager](https://github.com/yatsuki/v2manager)页面


## Transparent proxy

### What is "Transparent proxy"

> "A 'transparent proxy' is a proxy that does not modify the request or response beyond what is required for proxy authentication and identification". "A 'non-transparent proxy' is a proxy that modifies the request or response in order to provide some added service to the user agent, such as group annotation services, media type transformation, protocol reduction, or anonymity filtering".
>
> ​                                -- [Transparent proxy explanation in Wikipedia](https://en.wikipedia.org/wiki/Proxy_server#Transparent_proxy)



### Working principle

This module also contains a simple script that helping you to make transparent proxy via iptables. In fact , the script is just make some REDIRECT and TPROXY rules to redirect app's network into 65535 port in localhost. And 65535 port is listen by v2ray inbond with dokodemo-door protocol. In summarize, the App proxy network path is looks like :



**Android App** ( Google, Facebook, Twitter ... )

  &vArr;  ( TCP & UDP network protocol )

Android system **iptables**      [ localhost inside ]

  &vArr;  ( REDIRECT & TPROXY iptables rules )

[ 127.0.0.1:65535 Inbond ] -- **V2Ray** -- [ Outbond ]

  &vArr;  ( Shadowsocks, Vmess )

**Proxy Server** ( SS, V2Ray)   [ Internet outside ]             

  &vArr; ( HTTP, TCP, ... other application protocol ) 

**App Server** ( Google, Facebook, Twitter ... )



## 卸载

1. 删除v2manager应用 `pm uninstall co.lintian.v2manager`
2. 在Magisk Manager中停用并删除本插件
3. 删除v2ray目录 `rm -rf /data/v2ray`


## Project V

Project V is a set of network tools that help you to build your own computer network. It secures your network connections and thus protects your privacy. See [ProjectV website](https://www.v2fly.org/) for more information.



## License

[The MIT License (MIT)](https://raw.githubusercontent.com/v2fly/v2ray-core/master/LICENSE)
