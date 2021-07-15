# Dot Diary 〜みっかぼうずのやぼう〜
「Dot Diary」は、日記形式でゲームのように楽しみながら目標を記録、管理するアプリケーションです。<br>
<br>
<img src="https://user-images.githubusercontent.com/78312000/123427418-8e8e4f80-d5ff-11eb-9366-38d58a366668.gif" width="600">

## サイト概要

「Dot Diary」では、達成したい目標を設定し記録する事で、進捗に応じて様々な要素が変化します！<br>
使用方法の大まかな流れは以下の通りです。
<br>
1. ユーザ登録後、自分の「目標」を設定します。<br>
2. 目標の為にしたことを投稿すると、目標のレベルが上昇します。<br>
<img src="https://user-images.githubusercontent.com/78312000/123500172-0cda0880-d677-11eb-82d9-0b4857b8a914.gif" width="600">
3. 投稿回数に応じて、画像に表示されるモンスターやステージが変化するなど、日々の成長を視覚的に楽しむことができます。<br>
<br>
<p>
  <img src="https://user-images.githubusercontent.com/78312000/123501680-9a225a80-d681-11eb-8b8a-d188b8960c24.png" width="300">
  <img src="https://user-images.githubusercontent.com/78312000/123501682-a0183b80-d681-11eb-9b18-3354c65a53e5.png" width="300">
  <img src="https://user-images.githubusercontent.com/78312000/123501685-a3132c00-d681-11eb-89a2-c9e8b2e57922.png" width="300">
  <img src="https://user-images.githubusercontent.com/78312000/123518524-3d568c80-d6e1-11eb-999e-a5caa81dbe24.png" width="300">
 </p>
4. Lv.100 になればその目標は達成です！目標達成に向けて、Todoリスト機能もぜひご活用ください。<br>
<br>
<img src="https://user-images.githubusercontent.com/78312000/123424271-964bf500-d5fb-11eb-9d15-a62ca049dd08.png" width="1000">
<br>

## サイトテーマ

楽しみながら目標を記録、管理する

### テーマを選んだ理由

このテーマを選んだ理由は、1 日の頑張りを楽しみながら振り返りたいと思ったからです。
学習カリキュラムの中で「デイリーレポート」というものがあり、その日に学んだことを記録していましたが、そうすることで進捗が明確になるだけでなく、後日振り返りもできる為、重宝していました。<br>
日々レポートを記入する中で、自分の好きなゲーム感覚で、記録を残せば残すほどステージが進行していくようなアプリがあれば、もっと日々の振り返りや学習そのものを楽しめるのではないか、と考えるようになり、ポートフォリオのテーマとして採用することを決めました。<br>
勉強だけにとどまらず、1日頑張ったことを楽しみながら記録し、振り返ることで、ユーザの暮らしが少しでも楽しくなると幸いです。

### ターゲットユーザ

続けたいことや目標がある人、三日坊主を克服したいと思っている人、ゲーム好きな人

### 主な利用シーン

何か 1 つでも続けている、続けたいと思うことさえあればどのようなシーンでも利用できます。<br>
例えば、「ダイエットで-5kgを目指す」といった目標でも良いですし、「毎日朝 8 時に起きる」というのも立派な目標です。<br>
目標を決めた後は、1 日の終わりにその日したことを記録して、レベルアップしましょう！<br>
目標Lv.100達成に向けて、やるべきことを整理したい場合は「Todoリスト」機能で目標別にやることリストを作成できます。<br>
ある程度記録が増えてきたら、振り返ることも重要です。ステージやモンスターの変化を楽しみながら、過去の記録を確認しましょう！

## 工夫したポイント

### 機能

1. 投稿回数に応じた画像の変化や、レベルアップ時のアニメーションなど、毎日同じ作業の繰り返しという意識にならないよう、サイト内で動きや変化をつけました。<br>
目標Lv.100達成時専用の演出もありますので、ぜひサイトでご覧ください！<br>
2. Todoリストの作成や終了チェックがスムーズに行えるよう、全て非同期処理で機能を実装しました。<br>
検索もインクリメンタルサーチを用いていますので、目標別のソートや、キーワード検索がスムーズに実行できます。<br>
3. 新規登録時に、ユーザがまず何をするべきか分かりやすいよう、次に進むべきページやモーダルウインドウへ遷移するアイコンに動きをつけ、初めてのユーザでも一目で認識しやすいページを意識しました。<br>
4. 期限が近づいている目標やTodoリストがあれば、マイページで通知される為、期限超過のリスクを減らすことができます。<br>
5. OAuth認証による新規登録・ログインが可能で、Google・Twitter・Facebookのアカウントですぐに始められます。

### 非機能

1. RSpecによる単体テストや統合テストのコードを作成し、テストを自動化しました。<br>
Javascriptを用いた機能を複数実装しているため、js:trueオプションをつけたテストも含めています。<br>
2. バッチ処理によりゲストユーザのデータを1日1回リセットすることで、毎日同じ状態からサイトを試せるようにしています。

### リーダブルコード

1. BEM記法を用いてクラス名を付け、親セレクタを元にネストしたSCSSを書くことで、どの部分のSCSSであるかが分かりやすくなるよう心がけました。<br>
また、保守・運用がしやすいよう、カスタムプロパティを使い、BlockごとにSCSSファイルを分割しています。<br>
2. gem「Rubocop-airbnb」を用いて、コード解析と違反箇所のリファクタリングを実施しました。

### インフラ(AWS)

1. 耐障害性を考慮し、異なる2つのアベイラビリティゾーンでサーバーを冗長化させています。
2. セッションを維持するため、スティッキーセッションを利用しています。

## サイトURL

<https://dot-diary.online/>

## 設計書

### アプリケーション設計
[ER 図](https://drive.google.com/file/d/1BKTg2k6PQeldhfoDnKyMcuHOQnp0O5tL/view?usp=sharing)
<br>
[テーブル定義書](https://docs.google.com/spreadsheets/d/1yiQLRAzExqjTAvmJPudOBvqLG6T1lIXLw1otn_n_r4Y/edit?usp=sharing)
<br>
[詳細設計](https://drive.google.com/file/d/1aON1n62c7SiFD66LdimxbcjHDLSvUwlU/view?usp=sharing)
<br>
[ワイヤーフレーム](https://drive.google.com/file/d/1C_bq4RVYKyG_rNvWowWzDuzlGTFZMwMA/view?usp=sharing)
<br>
[画面遷移図](https://drive.google.com/file/d/1Ylr3uINj8zeC9yrcbIqHa-QDC93B5bcN/view?usp=sharing)

### AWSインフラ設計
[ネットワーク構成図](https://drive.google.com/file/d/15j9zsoOgIRl6TAyq4XD8fCS0S8_zXuIZ/view?usp=sharing)
<br>
[インフラ設計書](https://docs.google.com/spreadsheets/d/10Cwlml411NKFhjUz_hrzwpuLpKQG7uzjNpH1jTxI7ls/edit?usp=sharing)

## チャレンジ要素一覧

<https://docs.google.com/spreadsheets/d/1kZZIOO8pp7VQwR8ZbULpgdDx9cwXG6FIDJBMuwwEuzA/edit?usp=sharing>

## 開発環境

- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby
- フレームワーク：Ruby on Rails
- JS ライブラリ：jQuery
- IDE：Cloud9
