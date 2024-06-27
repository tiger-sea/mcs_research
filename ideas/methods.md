# Methods ideas

## Analysis method

### Regression models

- Space state model with MCMC
    - 柔軟な表現力
    - ベイズ推定によるパラメータの表現ができて，不確定さを表現できるから，何が嬉しいの？

- ベイズ構造時系列モデル

- ベイジアン変化点検出モデル
    - 心拍変動の変化点以前になにか特徴的な気象の変動があったと

### Tips

- 変数減少法とか

- 多重共線性

- CVの切り方，最後の数ヶ月を検証用データとして切っておくとか，Leave-one-out


## HRV parameters

- RMSSD, pNN50 (Time domain)

- LF, HF, LFnu, HFnu (Freq. domain)


## Meteorological factors

### Features (daily)

- Temperature (℃)
- Relative humidity (%) or Dew point
- Wind speed (m/sec)
- Atmospheric pressure (hPa)
    - above sea or above ground
- Total sun hour (hour)
- Total precipitation (mm)

---

Possible
- _Lunar cycle_
- _Weathr front_
- _Thunder_
- _Fog_
- _真夏日，猛暑日，ゲリラ豪雨，台風，爆弾低気圧(要定義確認)みたいな気象イベント_
- _連続した雨とか曇りの日_
- _平均だけとかじゃなくて，ある特定の時間のデータを使う_
- _四季_
- _曜日_

### Feature engineering

- Max
- Min
- Ave
- 前日との差 (前日に限らず)
- Max - Min
- ラグを取る
