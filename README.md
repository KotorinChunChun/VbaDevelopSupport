# VbaDevelopSupport
 VBA開発支援アドイン



## これは

VBEに機能を追加して、VBA開発を楽にするためのアドインです。

※ただしExcel専用

![](https://github.com/KotorinChunChun/VbaDevelopSupport/blob/master/docs/preview.png?raw=true)



## 使い方

アドインを実行するとメニューバーに「VBE開発支援」が増えるので、このコマンドを実行するだけ。

ただし、いずれのコマンドもアクティブなプロジェクトに対して実行されるので、処理したいプロジェクトのモジュールを開いてしっかり切り替えておくことを忘れずに。



## 機能一覧

* ソースをSRCにエクスポートする
* ソースをバックアップとエクスポートする
* ソースをYYYYMMDエクスポートする
* ソースコードのプロシージャ一覧を出力する
* プロジェクトのフォルダを開く
* プロジェクトを閉じる
* 全てのコードウインドウを閉じる
* イミディエイトウィンドウを空にする
* VBA開発支援アドインを終了する



## エクスポートの基本ルール

### 拡張子

ソースコードの拡張子は全て`.vba`です。

理由は次の通り

* 汎用エディタの関連付けを便利にするため。

* GitHubの自動言語判定でVBAと認識させるため。
* 拡張子が`.vba`でも、VBEへのインポートには支障がないため。

```
*.bas.vba 標準モジュール
*.cls.vba クラスモジュール／Sheet・Bookモジュール
*.frm.vba フォームモジュール
*.frm.frx フォームモジュールのバイナリ部分
```



### 除外ルール

一部のモジュールはエクスポートされません。

* 白紙のモジュール
* `Option Explicit`などの`Option`しか書かれていないモジュール
* 及び改行しか書かれていないモジュール
* 直前の`src`と容量の変化していない`.frm.frx`ファイル

これは、

* Excelの不要なシートモジュールの出力を防ぐため
* エクスポートのたびに必ず`.frm.frx`のバイナリが変化するため

です。



もし`.frm.frx`を更新したいのであれば、適当な図形を増やして容量を変化させるか既存の`../src`のファイルを消してからエクスポートしてください。



## ソースをエクスポートする

`../src/`にソースコードをエクスポート、`../bin/`にプロジェクト一式を複製します。

GitHubで管理したい場合におすすめです。

#### 入力（プロジェクトの保存場所）

プロジェクトと同一フォルダのファイルすべてをbinに複製します。

```
/任意のフォルダ/AddinName.xlam
```

#### 出力

```
/bin/AddinName.xlam
/src/CodeName.bas.vba
```

※一旦srcフォルダごと削除してからエクスポートするため、大事なファイルをここに入れると消されます。



## ソースをバックアップとエクスポートする

上記と同じようにエクスポートしつつ、`../backup/`フォルダに日付情報付きでコピーします。

GitHub、WinMerge両方で管理したい場合におすすめです。

#### 入力（プロジェクトの保存場所）

プロジェクトと同一フォルダのファイルすべてをbinに複製します。

```
/任意のフォルダ/AddinName.xlam
```

#### 出力

```
/bin/AddinName.xlam
/src/CodeName.bas.vba
/backup/bin/YYYYMMDD_HHMMSS_AddinName.xlam
/backup/src/YYYYMMDD_HHMMSS/CodeName.bas.vba
```

※srcにエクスポートしたものが、backupに複製されます。



## ソースをYYYYMMDDにエクスポートする

`./src/`に日付フォルダを作成してソースコードをエクスポートします。

WinMergeによるバージョン管理をする場合におすすめです。

#### 入力（プロジェクトの保存場所）

```
/AddinName.xlam
```

#### 出力

```
/src/YYYYMMDD_HHMMSS/CodeName.bas.vba
```



## ソースコードのプロシージャ一覧を出力する

プロシージャ1件あたり1行となるように、新規エクセルブックにテーブル形式で出力します。

参考：https://qiita.com/Mikoshiba_Kyu/items/46b7243eb576848b3e55

### ユースケース

* 関数をデータベース化する場合
* 関数名の`Public/Private`つけ忘れをチェックする場合（テーブル右端参考）
* 引数や戻り値の型の統一をする場合



## VbeDevelop.basについて

検証で使ったものや、開発中のもの、ネットからコピペしたものなど、ソースコードがぐちゃぐちゃです。

お宝が隠れてるかも・・。



## 実行時エラーが出た場合や改造する人へ

あまり丁寧にエラー処理していません。フォルダ作成とかでエラーが出るかもしれません。

<br>

実行時エラーが出たら、メニューが動作しなくなります。いずれかの方法で復旧させてください。

* エクセルを再起動する
* F5を押して`AppMain.Reset_Addin`を実行する



## 今後の予定

* インポート対応
* プロシージャ別ファイル出力
* プロシージャ単位アップデート
* CustomUI XMLの読込
* テストの生成
* テストへのジャンプ
* テストの実行
* モジュールテストの実行
* マクロの記録で生成されたコードの最適化



## 利用者へ

使用は自己責任でお願いします。何が起きても作者は保証できません。


