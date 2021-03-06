# 第2班

　颯爽と走らない僕らのマインドストーム


# プログラムについて

　このプログラムは、Ruby合宿2017年春にて作成したプログラムである。

　内容は、障害物の見えない(実際に走るロボットにはわからない)迷路を
走破させるものである。


# アプリケーションの起動方法

　WindowsPCにてコマンドプロンプトを開きソースコードの置かれている
ディレクトリにアクセスして以下のコマンドを実行する。

> ruby main.rb

# アプリケーションについて
## 大まかな流れ
	1. マップと初期位置が与えられる。
	2. PCにてマップをどのように動くかを調べる。
	3. 得られたコースをナビ側のEV3を通してプレイヤー側のEV3に送信する。
	4. プレイヤー側のEV3は得られたコース情報を元にコースを走る。


## 具体的な手順
	ダイクストラのアルゴリズムでマップ解析を行いルートを決定する。
	解析したルートを※1のようなデータの形に成形する。
		↓
	※1のデータを一つの数値に変換する。
		↓
	ナビ側のEV3からプレイヤー側のEV3にデータを送信する。
		↓
	プレイヤー側のEV3にて16進数を復調する。
		↓
	プレイヤー側のEV3がルートアルゴリズムをもとにコースを走らせる。


## ※1 ルートは次のようにして表す
	上: 00
	下: 01
	右: 10
	左: 11
	配列に格納して先出しした順番がそのままルートとなる

	例) ルートが"上, 下, 右, 下"の場合"[00, 01, 10, 01]"と配列に格納される

![2-1](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-1.JPG)

![2-2](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-2.JPG)

![2-3](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-3.JPG)

![2-4](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-4.JPG)

![2-5](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-5.JPG)

![2-6](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-6.JPG)

![2-7](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-7.JPG)

![2-8](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/2-8.JPG)

![field](https://github.com/RubyCamp/rc2017sp_g2/wiki/images/Field.JPG)
