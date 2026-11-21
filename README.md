# HTC 天气时钟小组件 · 非 HTC 设备修复版

基于 HTC 官方天气时钟（`com.htc.widget.weatherclock` 10.10.1059527）反编译修改，让这套经典翻页时钟能在非 HTC 设备上正常显示中文、并修正几处交互问题。

测试设备：moto ZY22JRF4HG / Android 16 (API 36) / 1080×2640 / density 356。

## 版本记录

| 版本 | 改动 |
| --- | --- |
| v1.2.22–23 | 城市名字号从 18sp 缩到 16sp；「以晴为主」合并进城市名行，显示为 `聊城 · 以晴为主`；修正与日期行的重叠 |
| v1.2.24 | 设置界面全面汉化（其他设置、温度单位、时钟样式）；城市搜索 HTTP 超时 10s → 5s |
| v1.2.26 | 修复「选择城市」列表里「当前位置」下方那条无文字的空白条目 |
| v1.2.28 | 扩大点击热区：天气信息条与卡片空白区域改为进入设置页 |

## v1.2.28：点击热区

**现象**：点小组件上的城市名进设置，成功率很低；稍微点偏就跳转到天气网页；卡片下方大片空白完全没有反应。

**原因**：用 `uiautomator dump` 抓 RemoteViews 层级后实测各块热区——

| 区域 | view id | bounds | 原行为 |
| --- | --- | --- | --- |
| 时钟 | `digital_clock` | 1008×383 | 打开闹钟 |
| 天气信息条 | `info_block` | 888×135 | **打开天气网页** |
| 城市名文字 | `city_name` | 238×44 | 进入设置（唯一的设置入口） |
| 天气图标 | `sun_block` | 290×272 | 打开天气网页 |
| 温度 | `temp_block` | 120×135 | 打开天气网页 |
| 根容器 | `widget_layout` | 1008×1074 | 没绑任何事件 |

**改法**（只动 `smali/com/htc/widget/weatherclock/res/WeatherClock4x2Res.smali`）：

- `getSettingClickIds()`：`[city_name]` → `[city_name, info_block, widget_layout]`
- `getWeatherClickIds()`：原本直接返回 `getOptionIds()`（信息条 + 温度 + 天气图标），改为返回 `[temp_block, sun_block]`

`getOptionIds()` 保持原样——`WeatherBase.showLocationOption()` 还依赖它控制这三块的显隐，改数组会破坏显示逻辑。

**结果**：

| 点击位置 | 行为 |
| --- | --- |
| 时钟区 | 闹钟 |
| 天气图标、温度 | 天气网页（入口保留） |
| 信息条任意位置（日期 / 城市名 / 空白） | 设置页 |
| 卡片下方空白 | 设置页 |

设置热区从 238×44 px 扩大到 888×135 px，另加整张卡片兜底，约 11 倍。

## v1.2.26：城市列表空白条目

「选择城市」界面「当前位置」下方有一条只有单选按钮、没有文字的空白行。

根因：`HtcClockSetting.getWorldClockCity()` 里 `loadMultiAppLocations()` 返回了两个 `getName()` 为空串的 `WeatherLocation`，第 0 项被当作「当前位置」，第 1 项被无条件加进列表 → 渲染成空白。

修复：在三处 `getMapByLocation()` 加入列表前补 `TextUtils.isEmpty(name)` 判断，为空则跳过。详见 [patches/README.md](patches/README.md)。

## 安装

安装包在 [Releases](https://github.com/Siwone/htc-weatherclock-fix/releases/latest) 页面，选最新版本的 `HTC-WeatherClock-vX.Y.Z-*.apk` 下载。

```bash
adb install -r HTC-WeatherClock-v1.2.28-cityclick.apk
```

签名与原版不同，如果之前装的是官方版本，需要先卸载（卸载会清掉桌面小组件，重装后要重新添加到桌面）。

## 已知限制

- 桌面小组件被拉伸到大于 4×2 时，内容仍按 4×2 布局排布，底部会留白（现在点空白也能进设置）。
- 主题、双城市（Dual）布局相关的 `WeatherClock4x2ResLeft/Right` 未做同样修改，仅在 Single 4×2 上验证。
- 版本号写在二进制 `AndroidManifest.xml` 里，`apktool b` 每次会还原，必须打包前重新替换，见 [docs/build.md](docs/build.md)。

## 免责声明

仅供个人设备的兼容性研究与自用。HTC、HTC Sense 及相关商标与原始代码版权归宏达国际电子股份有限公司所有。请勿用于商业用途或二次分发。
