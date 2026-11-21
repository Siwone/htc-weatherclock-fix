.class public Lcom/htc/widget/weatherclock/res/WeatherClock4x2Res;
.super Lcom/htc/widget/weatherclock/res/WidgetRes;
.source "WeatherClock4x2Res.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 5
    invoke-direct {p0}, Lcom/htc/widget/weatherclock/res/WidgetRes;-><init>()V

    return-void
.end method


# virtual methods
.method public getCityName5x5Id()I
    .locals 1

    .prologue
    .line 113
    const/4 v0, 0x0

    return v0
.end method

.method public getCityNameIconId()I
    .locals 1

    .prologue
    .line 118
    const/4 v0, 0x0

    return v0
.end method

.method public getCityNameId()I
    .locals 1

    .prologue
    .line 108
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->city_name:I

    return v0
.end method

.method public getCityNameTalkback5x5Id()I
    .locals 1

    .prologue
    .line 128
    const/4 v0, 0x0

    return v0
.end method

.method public getCityNameTalkbackId()I
    .locals 1

    .prologue
    .line 123
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->city_name_t:I

    return v0
.end method

.method public getClockClickIds()[I
    .locals 3

    .prologue
    .line 27
    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->digital_clock:I

    aput v2, v0, v1

    return-object v0
.end method

.method public getDigitalClockId()I
    .locals 1

    .prologue
    .line 133
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->digital_clock:I

    return v0
.end method

.method public getHighTempDegreeId()I
    .locals 1

    .prologue
    .line 88
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->high_temperature_degree:I

    return v0
.end method

.method public getHighTempId()I
    .locals 1

    .prologue
    .line 83
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->high_temperature:I

    return v0
.end method

.method public getHolidayId()I
    .locals 1

    .prologue
    .line 103
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->holiday:I

    return v0
.end method

.method public getLocationBlockId()I
    .locals 1

    .prologue
    .line 143
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->location_block:I

    return v0
.end method

.method public getLocationTextId()I
    .locals 1

    .prologue
    .line 148
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->location_text:I

    return v0
.end method

.method public getLowTempDegreeId()I
    .locals 1

    .prologue
    .line 98
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->low_temperature_degree:I

    return v0
.end method

.method public getLowTempId()I
    .locals 1

    .prologue
    .line 93
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->low_temperature:I

    return v0
.end method

.method public getNoWeatherDataId()I
    .locals 1

    .prologue
    .line 138
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->condition_text:I

    return v0
.end method

.method public getNoWeatherDataIds()[[I
    .locals 6

    .prologue
    const/4 v5, 0x2

    const/4 v4, 0x1

    const/4 v3, 0x0

    .line 15
    new-array v0, v5, [[I

    const/4 v1, 0x3

    new-array v1, v1, [I

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->location_block:I

    aput v2, v1, v3

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->temp_block:I

    aput v2, v1, v4

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->sun_block:I

    aput v2, v1, v5

    aput-object v1, v0, v3

    new-array v1, v4, [I

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->info_block:I

    aput v2, v1, v3

    aput-object v1, v0, v4

    return-object v0
.end method

.method public getOption5x5Ids()[I
    .locals 1

    .prologue
    .line 48
    const/4 v0, 0x0

    new-array v0, v0, [I

    return-object v0
.end method

.method public getOptionIds()[I
    .locals 3

    .prologue
    .line 42
    const/4 v0, 0x3

    new-array v0, v0, [I

    const/4 v1, 0x0

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->info_block:I

    aput v2, v0, v1

    const/4 v1, 0x1

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->temp_block:I

    aput v2, v0, v1

    const/4 v1, 0x2

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->sun_block:I

    aput v2, v0, v1

    return-object v0
.end method

.method public getSettingClick5x5Ids()[I
    .locals 1

    .prologue
    .line 37
    const/4 v0, 0x0

    new-array v0, v0, [I

    return-object v0
.end method

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

.method public getSunBlockId()I
    .locals 1

    .prologue
    .line 58
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->sun_block:I

    return v0
.end method

.method public getSunId()I
    .locals 1

    .prologue
    .line 53
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->sun:I

    return v0
.end method

.method public getTempCFId()I
    .locals 1

    .prologue
    .line 78
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->temperature_c_f:I

    return v0
.end method

.method public getTempDegreeId()I
    .locals 1

    .prologue
    .line 68
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->temperature_degree:I

    return v0
.end method

.method public getTempId()I
    .locals 1

    .prologue
    .line 63
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->temperature:I

    return v0
.end method

.method public getTempSymbolId()I
    .locals 1

    .prologue
    .line 73
    sget v0, Lcom/htc/widget/weatherclock/sub/R$id;->temperature_symbol:I

    return v0
.end method

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

.method public getWeatherDataIds()[[I
    .locals 6

    .prologue
    const/4 v5, 0x2

    const/4 v4, 0x1

    const/4 v3, 0x0

    .line 8
    new-array v0, v5, [[I

    new-array v1, v4, [I

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->location_block:I

    aput v2, v1, v3

    aput-object v1, v0, v3

    const/4 v1, 0x3

    new-array v1, v1, [I

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->info_block:I

    aput v2, v1, v3

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->temp_block:I

    aput v2, v1, v4

    sget v2, Lcom/htc/widget/weatherclock/sub/R$id;->sun_block:I

    aput v2, v1, v5

    aput-object v1, v0, v4

    return-object v0
.end method
