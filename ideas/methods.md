# Methods ideas

## Analysis method

### Regression models

- Space state model with MCMC
    - 柔軟な表現力
    - ベイズで何が嬉しいのか:
        - パラメータを確率変数として考え，分布を推測するからパラメータの解釈がしやすい，伝統的な統計学ではパラメータは一点の定数と考えるから解釈が難しい．"パラメータがこの範囲にあるのはこの確率"と言える．
        - 不確実さを表現できる，つまり信用区間で"データが得られた時のパラメータの確率の幅"を表現できるから，このくらいの幅で変化するんだなって定量的に示せる．不確実性は事後分布として示されるから，EAP推定値とかだけでなく，変動幅も評価できる．
        - 一貫した流れで分析ができる，つまり，推論の流れがデータによって変わらないから信頼できる結果が得られやすい．
        - ASA声明

- ベイズ構造時系列モデル

- ベイジアン変化点検出モデル
    - 心拍変動の変化点以前になにか特徴的な気象の変動があったと

- ARモデル系のパラメータをベイズ推定

__どうして状態空間モデルを使うのか，or どうしてARモデル系を使うのか．そこをはっきりさせたい．__

__ベイズ統計を使うと何が嬉しいの?__

### Tips

- 変数減少法とか

- 多重共線性

- CVの切り方，最後の数ヶ月を検証用データとして切っておくとか，Leave-one-out

- ベイズ統計で分析する時に報告すべき情報たち [Bayesian analysis guildelines](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8526359/)
    - 事前分布は何を設定したの?
    - 信頼区間は何を設定したの?
    - 感度分析 (?)
    - MCMCの収束はどう判断したの?
    - どんなモデルを使ったの?

### Visualization

- 似た天気の日は似たHRVの値になるのかクラスタリングしてみたり．

- いつもよりHRVの値が違う日に注目して，その日の24時間分の天気を見てなんか特徴的な天気がないか見てみる．

- インパルス応答とか見てみたり．

## HRV parameters

- RMSSD, pNN50 (Time domain)

- LF, HF, LFnu, HFnu (Freq. domain)

- [HRV parameters calculation](https://github.com/MarcusVollmer/HRV)

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
