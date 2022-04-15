## STEP0: 環境構築

### 小椎尾先生のワークスペース

https://gitlab.jsk.imi.i.u-tokyo.ac.jp/hiraoka/auto_stabilizer_setup

この内visionありを環境構築する。 catkin_ws/ を catkin_ws/"ワークスペースの名前"/ に読み替えること。

### box_tutorial用環境構築

.rosinstallに以下を追記
```yaml
- git:
    local-name: box_tutorial
    uri: git@github.com:98shimpei/box_tutorial.git
```

ビルド
```bash
$ wstool update
$ catkin build box_tutorial
$ source devel/setup.bash
```

## STEP1: まず動かしてみる
```bash
$ rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch PROJECT_FILE:=`rospack find box_tutorial`choreonoid/config/JAXON_RED_RH_BOX.cnoid
```
別ウィンドウで
```lisp
$ roseus
(load "package://push-recovery/push-recovery-foot-guided.l")
(robots-init "jaxon_red")
(start-footguided-modification)
(send *ri* :go-pos 1 0 0)
(send *ri* :go-velocity 0 0 0)
```
## STEP2: choreonoidでシミュレーション環境を作る
参考：  
　choreonoidのtankチュートリアル ： https://choreonoid.org/ja/manuals/1.7/simulation/tank-tutorial/index.html  
　choreonoidのbodyファイルチュートリアル： https://choreonoid.org/ja/manuals/1.7/handling-models/modelfile/modelfile-newformat.html  

choreonoidを起動する
```bash
$ rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch

# 既存の環境を使う場合は以下（JAXON_RED_RH_BOX.cnoidの部分を変える）
$ rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch PROJECT_FILE:=`rospack find box_tutorial`choreonoid/config/JAXON_RED_RH_BOX.cnoid
```
### 画面の見方  
詳しくはココ！：https://choreonoid.org/ja/manuals/1.7/basics/mainwindow.html

よく使う部分のざっくり説明  
![choreonoid_gamen](https://user-images.githubusercontent.com/53897559/163540932-8507a49a-90b7-4eb7-8f43-7ea764a0eb2e.png)

- ①：（シミュレーションを停止したあと）アニメーションの再生・停止
- ②：シークバー。このバーをダブルクリック長押しすることでアニメーションをゆっくり再生することも可能。
- ③：シークバーの時間範囲の設定。最初は1000に設定されておりわかりにくいので200ぐらいにすると良い。
- ④：現在の状態をワールド初期状態に設定。後述。
- ⑤：シミュレーションの停止
- ⑥：ワールドの構成。ツリー状になっている。ドラッグ＆ドロップで位置を変更可能
- ⑦：ボディや関節の位置などの設定。最初は隠れているかも、ドラッグで引き出す。
- ⑧：シミュレーション画面
- ⑨：エラー文など。最初は隠れているかも。

hrpsysを用いてロボットを動かす場合、一度シミュレーションを停止したら再開は不可。一度行ったシミュレーションは①のボタンで再生できる。  
⑧は左ドラッグで回転、スペースを押しながらマウスを動かして平行移動、ホイールで拡大縮小。

### ボディの読み込み・設定・プロジェクトの保存
シミュレーションを停止したあと、②のシークバーを端まで動かして初期状態にする。

ファイル>読み込み>ボディ、　catkin_ws/src/box_tutorial/choreonoid/models/box.body

⑥の一番下にboxが出現するので、チェックボックスにチェックを入れる。  
→　⑧の画面に黄色い箱が出現する。

⑥のboxをドラッグ＆ドロップでworldの中に入れる  
→　これでシミュレーションの対象になる。

⑥のboxを選択した状態で⑦で位置を調整して適当な場所に移動する。

⑥のworldを選択してから④を押して現在のワールドを初期状態に設定する。  
→　⑧に設定できた感じの文章が流れる

ファイル＞名前をつけてプロジェクトを保存、　catkin_ws/src/box_tutorial/choreonoi/config/JAXON_RED_RH_hoge.cnoid  
※ hogeの部分を適宜変更。

### 作成したプロジェクトの実行
```bash
$ rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch PROJECT_FILE:=`rospack find box_tutorial`choreonoid/config/JAXON_RED_RH_hoge.cnoid
```

### Tips
**ボディファイルの場所**
choreonoid/share/modelの下や、rtm-ros-robotics/rtmros_choreonoid/jvrc_modelsなど。

## STEP3: bodyファイルを作る
参考：  
　choreonoidのbodyファイルチュートリアル： https://choreonoid.org/ja/manuals/1.7/handling-models/modelfile/modelfile-newformat.html

ボディファイルはyaml形式になっている。記法についてはこれなどを参考に。https://magazine.rubyist.net/articles/0009/0009-YAML.html

チュートリアルを書こうと思ったけど公式のチュートリアルよりわかりやすくなる気がしないのでサンプルと比べながら公式のものを見てください・・・。

## STEP4: carry_boxデモ
euslisp/carry_box.lに詳しく書きました。

hrpsysの様々なコマンドは https://github.com/start-jsk/rtmros_common/blob/master/hrpsys_ros_bridge/test/hrpsys-samples/README.md を参照

※今後更新予定・・・
