# 补丁说明

所有修改都是直接改 smali（原包用 `apktool d -r` 反编译，没有 `values/*.xml`，字符串和尺寸只能走代码）。

## 1. 点击热区 · `res/WeatherClock4x2Res.smali`

完整文件见同目录 `WeatherClock4x2Res.smali`，关键两个方法：

```smali
.method public getSettingClickIds()[I
    .locals 3

    .prologue
    .line 32
    const/4 v0, 0x3

    new-array v0, v0, [I

    const/4 v1, 0x0

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->city_name:I

    aput v2, v0, v1

    const/4 v1, 0x1

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->info_block:I

    aput v2, v0, v1

    const/4 v1, 0x2

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->widget_layout:I

    aput v2, v0, v1

    return-object v0
.end method
```

```smali
.method public getWeatherClickIds()[I
    .locals 3

    .prologue
    .line 22
    const/4 v0, 0x2

    new-array v0, v0, [I

    const/4 v1, 0x0

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->temp_block:I

    aput v2, v0, v1

    const/4 v1, 0x1

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->sun_block:I

    aput v2, v0, v1

    return-object v0
.end method
```

**不要动 `getOptionIds()`**。它的返回值除了给 `getWeatherClickIds()` 用，还被 `WeatherBase.showLocationOption()` 拿去遍历设置可见性：

```smali
invoke-virtual {p3}, L.../WidgetRes;->getOptionIds()[I
...
invoke-virtual {v5, v4, v6}, Landroid/widget/RemoteViews;->setViewVisibility(II)V
```

少一个 id，对应区块在「只显示天气」模式下就不会被隐藏。

调用顺序（`WeatherBase.getAllViews` 链路）是 `setClockClick` → `setWeatherClick` → `setSettingClick`，三个方法各自按 view id 绑不同的 `PendingIntent`，同一个 id 后绑的覆盖先绑的，所以 `info_block` 放在 `setSettingClick` 里就能盖掉原来的天气 Intent。

## 2. 城市列表空白项 · `setting/HtcClockSetting.smali`

方法 `getWorldClockCity(String)`，`.locals` 从 7 扩到 8 供临时寄存器使用。三处 `getMapByLocation()` 前都加判断，模板：

```smali
invoke-virtual {vX}, Lcom/htc/lib2/weather/WeatherLocation;->getName()Ljava/lang/String;
move-result-object vY
invoke-static {vY}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
move-result vY
if-nez vY, :skip        # isEmpty 返回 1（空）时跳过，非空才加入
```

三处位置：

1. `:cond_1` —— 查到记录的分支
2. `:goto_1` —— `mLocs` 数组遍历循环（**空白条目的实际来源**）
3. `:goto_2` —— `cond_4` 兜底分支

**易错点**：`TextUtils.isEmpty()` 为空返回 true(1)，"为空则跳过"必须写 `if-nez`。写成 `if-eqz` 语义正好反了，会把空对象留下、把正常城市过滤掉。

## 3. 排版美化 · `view/WeatherClock4x2ViewSingle.smali`

方法 `getAllViews`，`.locals 2` → `.locals 6`，在 `WeatherBar.apply()` 之后追加：

```smali
const/4 v3, 0x2                                  # COMPLEX_UNIT_SP
const/high16 v4, 0x41800000                      # 16.0f
invoke-virtual {v0, v1, v3, v4}, Landroid/widget/RemoteViews;->setTextViewTextSize(IIF)V   # city_name

const/4 v3, 0x1                                  # MARGIN_TOP
const/high16 v4, 0x41e80000                      # 29.0f
const/4 v5, 0x1                                  # COMPLEX_UNIT_DIP
invoke-virtual/range {v0 .. v5}, Landroid/widget/RemoteViews;->setViewLayoutMargin(IIIFI)V
```

城市名文本改成 `城市名 + " · " + 天气描述`，再把 `condition_text` 设为 `GONE`。

字号从 18sp 缩到 16sp 后，原来给 18sp 预留的 `marginTop` 会显得偏大、文字上顶与日期行重叠，所以同时把 marginTop 调到 29dp 补偿。

## 4. 汉化 · `smali_classes2/.../openmeteo/*.smali`

`SettingsExtras`（13 处）、`TemperatureUnitActivity`（3 处）、`ClockStyleActivity`（8 处，含 `LABELS` / `DESCRIPTIONS` 数组）。

`-r` 模式下没有 `values-zh/strings.xml` 可用，只能把 `const-string` 换成中文，写成 `\uXXXX` 转义最稳：

```smali
const-string v0, "\u52a8\u6001\u5929\u6c14\u56fe\u6807"
```

## 5. 搜索超时 · `setting/weather/AccuWeatherOnlineSearchHelper.smali`

`getHttpText` 里的连接超时：

```smali
const/16 v1, 0x1388      # 5000ms，原 0x2710 = 10000ms
```

## 调试技巧

release 包的 `LogUtils.d` 受 `DEBUG_FLAG`（`com.htc.a.b.a.a`）控制，恒为 false，打桩不输出。调试时直接用系统 Log：

```smali
const-string v0, "GWC"
invoke-static {v1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
move-result-object v1
invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
```

看小组件真实点击区域别靠截图估算，用 `uiautomator dump` 拿 RemoteViews 的 bounds，误差能差好几倍。
