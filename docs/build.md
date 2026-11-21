# 构建说明

## 环境

| 组件 | 版本 |
| --- | --- |
| JDK | 17 |
| apktool | 2.11.0 |
| Android build-tools | 35.0.0（`zipalign`、`apksigner`、`aapt`） |
| 目标设备 | Android 16 (API 36) |

## 1. 反编译

```bash
java -jar apktool.jar d -r -f -o work base.apk
```

`-r` 表示不解码资源，`res/` 与 `resources.arsc` 保持二进制原样。好处是回编译不会因为资源 ID 错乱出问题；代价是没有 `values/*.xml`，改文字、改尺寸都只能写 smali。

## 2. 改代码

按 [../patches/README.md](../patches/README.md) 改对应 smali。

## 3. 改版本号（每次打包必做）

`apktool.yml` 里 `versionInfo` 是 null，版本号在二进制 `AndroidManifest.xml` 的字符串池里。反编译目录中的 `AndroidManifest.xml` 是 AXML 二进制文件，直接按 UTF-16LE 做等长替换：

```python
d = open('work/AndroidManifest.xml', 'rb').read()
old = '10.10.1059527-android36-v1.2.15'.encode('utf-16-le')
new = '10.10.1059527-android36-v1.2.28'.encode('utf-16-le')
assert len(old) == len(new)
open('work/AndroidManifest.xml', 'wb').write(d.replace(old, new))
```

**这一步必须在 `apktool b` 之前做**。`apktool b` 编译完成后会把 `AndroidManifest.xml` 还原成原始二进制（从 `original/` 复制），并且会顺带删掉目录里的备份文件，所以：

- 不要在编译后检查目录里的 manifest，要看产物；
- 每次重新编译都要重做替换，不能只做一次。

验证：

```bash
aapt dump badging out-unsigned.apk | head -1
# versionName='10.10.1059527-android36-v1.2.28'
```

## 4. 编译

```bash
java -jar apktool.jar b work -o out-unsigned.apk
```

## 5. 对齐 + 签名

```bash
zipalign -f 4 out-unsigned.apk out-aligned.apk

java -jar apksigner.jar sign \
  --ks htc-fix.jks --ks-key-alias htcfix \
  --ks-pass pass:<你的密码> --key-pass pass:<你的密码> \
  --out HTC-WeatherClock-vX.Y.Z.apk out-aligned.apk
```

密钥库自备（`keytool -genkeypair` 生成），**不要提交到仓库**。签名要与上一次安装的一致，否则 `adb install -r` 会报 `INSTALL_FAILED_UPDATE_INCOMPATIBLE`，只能先卸载——卸载会把桌面上的小组件一起清掉，需要重新添加。

`-r` 模式下用的是 `build-tools/<ver>/lib/apksigner.jar`；`apksigner.bat` 需要 `JAVA_HOME`，直接 `java -jar` 更省事。

## 6. 验证

```bash
adb install -r HTC-WeatherClock-vX.Y.Z.apk
adb shell dumpsys package com.htc.widget.weatherclock | grep versionName
```

改点击行为后，用 uiautomator 直接看真实热区：

```bash
adb shell uiautomator dump /sdcard/ui.xml
adb pull /sdcard/ui.xml .
```

`LauncherAppWidgetHostView` 下面那棵树就是 RemoteViews 展开后的真实布局，`clickable="true"` 的节点就是响应区域，`bounds` 是精确像素。截图目测估坐标会差很远（小组件的 bounds 往往比可见内容大一圈）。

点击验证：

```bash
adb shell input tap 600 600
adb shell dumpsys activity activities | grep topResumedActivity
```
