## STEP0: 環境構築

### 平岡さんのワークスペース

以下の平岡さんのワークスペースを環境構築。ただし、.rosinstallはこのディレクトリの.rosinstallを使用すること！！

https://gitlab.jsk.imi.i.u-tokyo.ac.jp/hiraoka/auto_stabilizer_config/-/tree/master/auto_stabilizer_config

catkin_ws/ を catkin_ws/"ワークスペースの名前"/ に読み替えること。

### box_tutorial用環境構築

ビルド
```bash
$ catkin build box_tutorial
$ catkin build ar_track_alvar control_tools log_plotter
$ source devel/setup.bash
```
また、auto_stabilizer_config/scripts/start-jaxon_red_with_mslhand-sim.sh内の、SOURCE_SCRIPTを必要に応じて変更しておくこと。

## STEP1: まず動かしてみる
```bash
$ rosrun auto_stabilizer_config start-jaxon_red_with_mslhand-sim.sh
$ byobu
```
byobuは複数のシェル環境を同時に起動して切り替えるツール。

F3,F4でタブ移動でき、F2で新しいタブを生成できる。F6でシェルの状態を維持したままデタッチでき、再度byobuと打つことで入り直すことができる。

5番タブに移動し、以下を一行ずつ実行することで歩行させることができる。
```lisp
$ roseus euslisp/simple_start.l
(send *ri* :go-pos 1 0 0) //1m歩く
(send *ri* :go-velocity 0 0 0) //その場で歩き続ける
(send *ri* :go-stop) //歩くのをやめる
```

その他のタブの詳細は以下
```bash
1番: roscore立ち上げ
2番: ネームサーバ立ち上げ
3番: choreonoid立ち上げ
4番: hrpsys,hrpsys_ros_bridge立ち上げ
5番: roseus立ち上げ用
```

## STEP2: choreonoidでシミュレーション環境を作る
参考：  
　choreonoidのtankチュートリアル ： https://choreonoid.org/ja/manuals/1.7/simulation/tank-tutorial/index.html  
　choreonoidのbodyファイルチュートリアル： https://choreonoid.org/ja/manuals/1.7/handling-models/modelfile/modelfile-newformat.html  

choreonoidを起動する
```bash
$ roslaunch auto_stabilizer_config choreonoid_JAXON_RED_WITH_MSLHAND.launch

# 既存の環境を使う場合は以下（JAXON_RED_WITH_MSLHAND_FLAT.cnoidの部分を変える）
$ roslaunch auto_stabilizer_config choreonoid_JAXON_RED_WITH_MSLHAND.launch PROJECT_FILE:=`rospack find box_tutorial`/cnoid/JAXON_RED_WITH_MSLHAND_FLAT.cnoid
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

### インタラクションの方法
⑧のシミュレーション画面を右クリックすることで編集モードと閲覧モードを切り替えられる。

編集モードでは、ロボットの各リンクにマウスオーバーすると黄色く光り、ドラッグするとそのリンクに力をかける（引っ張る）ことができる。
また、編集モード中にロボットのルートリンクを右クリックすることで、強制移動/強制保持を選ぶことができ、ロボットの位置を強制的に移動させることができる。

### ボディの読み込み・設定・プロジェクトの保存

※ プロジェクトを指定しないで起動すると、vision対応できていないので、自分で環境を作る場合FLATなどの環境を読み込んでから作ること。

シミュレーションを停止したあと、②のシークバーを端まで動かして初期状態にする。

ファイル>読み込み>ボディ、　catkin_ws/src/box_tutorial/models/box.body

⑥の一番下にboxが出現するので、チェックボックスにチェックを入れる。  
→　⑧の画面に黄色い箱が出現する。

⑥のboxをドラッグ＆ドロップでworldの中に入れる  
→　これでシミュレーションの対象になる。

⑥のboxを選択した状態で⑦で位置を調整して適当な場所に移動する。

⑥のworldを選択してから④を押して現在のワールドを初期状態に設定する。  
→　⑧に設定できた感じの文章が流れる

ファイル＞名前をつけてプロジェクトを保存、　catkin_ws/src/box_tutorial/choreonoi/config/JAXON_RED_WITH_MSLHAND_hoge.cnoid  
※ hogeの部分を適宜変更。

### 作成したプロジェクトの実行
```bash
$ roslaunch auto_stabilizer_config choreonoid_JAXON_RED_WITH_MSLHAND.launch PROJECT_FILE:=`rospack find box_tutorial`/cnoid/JAXON_RED_WITH_MSLHAND_hoge.cnoid
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
このデモでやること
- 各関節の動かし方
- 逆運動学を用いたエンドエフェクタの動かし方
- インピーダンス制御の使い方

choreonoidの起動
```bash
#3番タブにて
$ roslaunch auto_stabilizer_config choreonoid_JAXON_RED_WITH_MSLHAND.launch PROJECT_FILE:=`rospack find box_tutorial`/cnoid/JAXON_RED_WITH_MSLHAND_BOX.cnoid

#4番タブ起動
rossetlocal && rossetip && sato_hikitugi-source && roslaunch auto_stabilizer_config hrpsys_JAXON_RED_WITH_MSLHAND.launch

#5番タブにて
$ roscd box_tutorial/euslisp
$ roseus carry_box.l
```

euslisp/carry_box.lにコメントを詳しく書きました。

**デモの注意点**  
- \*ri\*と\*robot\*の違いを理解する。
- angle-vectorを送ったあとはwait-interpolationで動き終わるのを待つ。
- インピーダンス制御を行う前にオフセット除去を行う。特に、手のモデルが正しくない場合は、インピーダンス制御を始める直前にオフセット除去すると良い。

## STEP5: terrain_walkingデモ
**このステップは工事中**
このデモでやること
- 基礎的な歩行パラメータの設定
- footstepを指定した歩行

choreonoidの起動
```bash
$ rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch PROJECT_FILE:=`rospack find box_tutorial`/cnoid/JAXON_RED_RH_TERRAIN.cnoid
```
別タブでeusの起動
```bash
$ roscd box_tutorial/euslisp
$ roseus terrain_walking.l
```
euslisp/terrain_walking.lにコメントを詳しく書きました。

**デモの注意点**  
- 小椎尾先生のデフォルトの設定では着地位置修正を行うが、環境認識を行わない場合、着地位置がずれると困るので、着地位置修正を無効化しておく。
- 歩行に関するその他のオプションの設定方法はこちら（初心者は後回しで良い）：https://docs.google.com/presentation/d/1T0ZHgWZ8PXcXvk3VtwDO-1R7qfKsV6HyWswuABzgS-Y/edit#slide=id.g110eb2091ec_0_5
- 段差を登るとき、膝が伸び切ってしまうと、特異点に陥り足が暴れてバランスを崩すため、膝が伸び切らないように腰を落としておく。
- footstepsの設定方法は他にもあるので、hrpsys_ros_bridgeのチュートリアルも参考に。

## STEP6: carry_box_visionデモ
**このステップは工事中**
このデモでやること
- カメラの使い方
- rvizの使い方
- ARマーカーの認識
- euslispでのTFの使い方

choreonoidの起動
```bash
$ rtmlaunch hrpsys_choreonoid_tutorials jaxon_red_choreonoid.launch PROJECT_FILE:=`rospack find box_tutorial`/cnoid/JAXON_RED_RH_VISIONBOX.cnoid
```
別タブでt265ノードの起動
```bash
$ roslaunch realsense2_camera rs_t265_simulation.launch
$ #このノードは（なぜか）エラーが起きやすい。choreonoid立ち上げ後、ロボットの陽動がおさまる（stabilizerが入る）あたりで実行するとうまく行きやすい。
$ #このノードがずっと立ち上がらない場合はchoreonoidから立ち上げ直す。
```
別タブでrvizの起動
```bash
$ rosrun rviz rviz -d $(rospack find jsk_path_planner)/rviz/vision_walking.rviz
```
別タブでar_markerノードの起動
```bash
$ roslaunch box_tutorial ar_marker_simulation.launch
```
別タブでeusの起動
```bash
$ roscd box_tutorial/euslisp
$ roseus carry_box_vision.l
```

### ARマーカーを貼った箱を作る
まずはARマーカーを貼った箱を作る。  
例は models/ar_box1.body を参照。  
基本と同様に箱を作ったあと、ARマーカーのテクスチャを貼ったパーツを追加する。  
ARマーカーの画像の作るためには、以下を実行する。
```bash
$ roscd box_tutorial/models
$ rosrun ar_track_alvar createMarker
$ # 案内に従い、ほしいARマーカーの番号を指定。
```
テクスチャを貼ったパーツを作るには、IndexedFaceSetノードを使用する。  
とりあえず box_tutorial/models/ar_box1.body をコピペして作ると良い。

### RVIZの使い方
rvizはできることが色々あるので、JSK演習資料や公式：http://wiki.ros.org/ja/rviz#A.2BMMEw5TD8MMgw6jCiMOs- を参考に。  

よく使う部分のざっくり説明(該当部分がない場合は、隠れているので、矢印ボタンを押して表示させる)：

![rviz_gamen](https://user-images.githubusercontent.com/53897559/164146785-557b9eb1-cd67-4779-8190-f1028be990a8.png)

- ①：モード。基本はインタラクトモードにしておけば良い。
- ②：表示させるトピックの詳細
- ③：表示させるトピックの追加
- ④：メインビュー
- ⑤：特に便利な「Camera」ディスプレイ。ロボットの視界と、RVIZに表示させている各種マーカーを重ね合わせて表示できる。

メインビューは左ドラッグで回転、shift+左ドラッグまたは中ドラッグで平行移動、ホイールまたは右ドラッグで拡大縮小できる。  
②の表示させるトピックはチェックボックスで選択可能。また、力センサ等どのトピックを表示させるか切替可能。  
新しいトピックを表示させるには、③のaddボタンからディスプレイタイプやトピックを選んで表示させる。  

※小椎尾先生のワークスペースを使う場合のみ、global option の FixedFrame は odom_ground にする。その他のワークスペース（jaxon_tutorialなど）はmapにすることが多い。

### ARマーカーについて

公式ウィキ：http://wiki.ros.org/ar_track_alvar  
日本語おすすめページ：http://ishi.main.jp/ros/ros_ar_indiv.html

マーカーの大きさなどの情報を事前知識として持っておき、それを用いてマーカーの位置姿勢を認識する。
認識ノードを起動するlaunchファイルは box_tutorial/launch/ar_marker_simulation.launch においてある。

```xml
<launch>
  <arg name="marker_size" default="15.00" />
  <arg name="max_new_marker_error" default="0.08" />
  <arg name="max_track_error" default="0.5" />

  <arg name="cam_image_topic" default="/rs_l515/color/image_rect_color" />
  <arg name="cam_info_topic" default="/rs_l515/color/camera_info" />
  <arg name="output_frame" default="/rs_l515_color_optical_frame" />

  <node name="ar_track_alvar" pkg="ar_track_alvar" type="individualMarkersNoKinect" respawn="false" output="screen" >
    <param name="marker_size"           type="double" value="$(arg marker_size)" />
    <param name="max_new_marker_error"  type="double" value="$(arg max_new_marker_error)" />
    <param name="max_track_error"       type="double" value="$(arg max_track_error)" />
    <param name="output_frame"          type="string" value="$(arg output_frame)" />
    <param name="max_frequency"         type="double" value="30.0" />

    <remap from="camera_image"  to="$(arg cam_image_topic)" />
    <remap from="camera_info"   to="$(arg cam_info_topic)" />
  </node>
 </launch>
```

各パラメータの意味
- marker_size:マーカーの大きさ。単位はcm
- max_new_marker_eror:新しいマーカーを発見するときの許容誤差。あまり変更しなくて良い。
- max_track_error:マーカーを見続けているときの許容誤差。あまり変更しなくて良い。
- cam_image_topic:使用する画像トピック名
- cam_info_topic:使用するカメラ情報のトピック名
- output_frame:出力するTFの基準座標系。カメラの座標系を書く。

世の中にはその他にもARマーカーがある。AprilTagとかSTagとか。


### デモの注意点
- transform-listenerを用いてtfを読む
- :wait-transformでtfが繋がっているか確認してから、:lookup-transformでtfを受け取る
- ARマーカーまでのTFを用いて、箱や各手の位置姿勢を計算
- :translateで平行移動、:rotateで回転移動、:transformで座標系変換（平行＋回転）。詳しくはjmanualを参考に。

## STEP7: sato版terrain_walking_with_visionデモ
このデモでやること
- sato版のvisionを用いた歩行システムの環境構築・立ち上げ方を知る
- rosのログのとり方、再生方法を知る
- hrpsysのログのとり方、描画方法を知る
- 各種ツールの使い方

### 地形認識システム概要
このシステムは、不整地歩行での地形認識のために、環境点群をHeightmapに変換し、ニューラルネットに通すことで着地可能領域及び着地高さ・姿勢画像に変換し、着地位置姿勢を決めている。

### vision環境構築(ubuntu18.04)
python3を使うため、別のワークスペースを用意する必要がある（がんばれば一つのワークスペースでもできるかも）。
このディレクトリの.rosinstall_visionを使ってもう一つワークスペースを構築する。

**tensorflowのCPU版を使っているので、手元でやるときはGPU版使うと早くなりそう（結局やってない）**

package.xmlを書くのをサボっていたので、多少抜けが有るかも・・・。
```bash
#各種インストール
$ sudo apt install python3-pip python3
$ pip3 install --upgrade pip
$ pip3 install rospkg catkin_pkg empy
$ pip3 install tensorflow
$ #pip3 install tensorflow==2.6.2    バージョンは2.6.2を推奨
$ pip3 install opencv-python
$ echo "export TF_CPP_MIN_LOG_LEVEL=2" >> ~/.bashrc

#poly2triのインストール ※よりよい方法求む
#以下をクローンする場所はどこでも良い（後で消して良い）
$ git clone git@github.com:davidcarne/poly2tri.python.git
$ cd poly2tri.python
$ python3 setup.py build_ext -i
$ cp p2t.cpython-36m-x86_64-linux-gnu.so ~/.local/lib/python3.6/site-packages/. #python3のバージョンにより多少変わる?

#ワークスペースのビルドコマンド
$ catkin build -DPYTHON_EXECUTABLE=/usr/bin/python3 -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so
```


### シミュレーションの実行方法

```bash
#3番タブにて
$ roslaunch auto_stabilizer_config choreonoid_JAXON_RED_WITH_MSLHAND.launch PROJECT_FILE:=`rospack find box_tutorial`/cnoid/JAXON_RED_WITH_MSLHAND_TERRAIN.cnoid

#4番タブ起動
$ rossetlocal && rossetip && sato_hikitugi-source && roslaunch auto_stabilizer_config hrpsys_JAXON_RED_WITH_MSLHAND.launch

#5番タブにて
$ roscd box_tutorial/euslisp
$ roseus simple_start.l
$ (lower-waist 120)

#6番タブにて (点群をHeightmapに変換)
$ roslaunch jsk_path_planner recognize_terrain.launch simulation:=true

#7番タブにて（Heightmapを着地可能領域・高さ姿勢に変換）
$ #先程作成したvision用ワークスペースをsourceする
$ roslaunch terrain_recognition steppable_region.launch

#8番タブにて（rviz起動）
$ rosrun rviz rviz -d $(rospack find box_tutorial)/rviz/vision_walking.rviz

#もしt265を使う場合は別タブで以下のコマンドを使用（シミュレーション時）
$ roslaunch realsense2_camera rs_t265_simulation.launch
$ #このノードは（なぜか）エラーが起きやすい。choreonoid立ち上げ後、ロボットの陽動がおさまる（stabilizerが入る）あたりで実行するとうまく行きやすい。
$ #このノードがずっと立ち上がらない場合はchoreonoidから立ち上げ直す。
```

この後、5番タブでgoposなりgovelなりをすると良い

### rvizの情報の見方
![visionrviz](https://user-images.githubusercontent.com/53897559/164168271-e91c5971-e1be-4bef-aaa2-8eec5a43943b.png)
- ①：点群（PointCloud2）。トピックがいくつかある。
    - /rs_l515/depth/color/points_low_hz_resized：生点群を5Hzに落としてサイズを減らしたもの
    - /rt_accumulated_heightmap_pointcloud/output：点群を蓄積し、見てない範囲も推定したもの
    - /rt_accumulated_heightmap_pointcloud_odomrelative/output：自分の周りだけの点群。着地可能領域計算に用いる。
- ②：着地可能領域。緑の領域で示されている。三次元的に見えるが実際は二次元。ロボットの足の中心が着地できる場所を表す。
- ③：目標着地姿勢。水色の矢印で示されている。
- ④：点群除去領域。水色のボックス。BoundingBoxにチェックを入れると表示されるが、普段は邪魔なので隠している。このボックス内の点群は地形とみなされず無視される。物体を運搬する場合、物体の点群を無視するために大きめに設定する必要がある。src/jsk_path_planner/scripts/object_bbox_publisher.pyで設定している。
- ⑤：着地可能領域。上下が反転しているので注意・・・直す予定。
- ⑥：ロボットの視界と着地可能領域を合わせた画像。

### rosのログのとり方、再生のやりかた
ログを取るには、別タブで以下を起動しておく
別タブでeusの起動
```bash
$ roslaunch jsk_path_planner exp_record.launch bagfile:=file_name.bag
$ #file_nameの部分を適宜変更する
```
なお、記録されるトピックは jsk_path_planner/launch/exp_record.launch 内に設定されている。

取ったログは ~/.ros 以下に保存される。再生方法は以下。

roscoreの起動
```bash
$ roscore
```
別タブでrvizの起動
```bash
$ rosrun rviz rviz -d $(rospack find jsk_path_planner)/rviz/vision_walking.rviz
```
別タブでrosbagの起動
```bash
$ cd ~/.ros
$ rosbag play file_name.bag
$ #file_nameの部分を適宜変更
$ # -r で再生速度を設定可能。その他いろいろできるので-hで確認しよう。
```

なお、rviz画面にロボットが表示されない場合、rvizやrosbagを立ち上げる前に、適当なシミュレーションを起動・終了させると、ロボットが表示されるようになる。
また、一度ログを再生したあと、再度再生したい場合、rvizを再起動しないとTF関係のノードが正しく表示されないので注意。

rosbagに変わるログの再生方法として、rqt_bagもある。こちらはどのトピックを再生するか、どこから再生するかなどをGUIで設定できるが、動作が重い。

### hrpsysのログのとり方、グラフ描画方法
hrpsysのログを取るには、eus上で以下を行う

```lisp
(send *ri* :start-log) ;;ログ取り開始（正しくは、現在まで取っているログのリセット）

(send *ri* :save-log "保存場所の絶対パス") ;;ログ出力
(save-log) ;;小島さんのスクリプトを読み込んでいる場合、このコマンドでもログ出力可能（ログの名前もあとから設定可能）
```

グラフ描画方法は以下

ログを取った場所を開き、どのログでも良いので右クリック-> scripts -> plot.sh

![Screenshot from 2022-07-01 18-21-49](https://user-images.githubusercontent.com/53897559/176868516-d63bd60d-0dc0-427e-a72c-38b33570488f.png)

plot.yaml, layout.yamlを指定。plot.yamlはグラフ描画の関数を指定しており、layout.yamlはグラフのレイアウトを指定している。

![Screenshot from 2022-07-01 18-25-27](https://user-images.githubusercontent.com/53897559/176868560-42bd90c3-d953-42d2-acb6-80cceb1ca115.png)

グラフ画面。各軸ホイールを回すことで拡大・縮小可能。!!!ログが長い場合重く、反映が遅いので注意!!!

右クリックから様々な設定ができる。個人的によく使うのは以下。
- X,Y Axis: 横軸・縦軸の表示範囲を設定できる
- Hide: 必要ないグラフを隠せる。
- export: グラフをpngやsvg等で保存できる

**hrpsysの様々なコマンドは https://github.com/start-jsk/rtmros_common/blob/master/hrpsys_ros_bridge/test/hrpsys-samples/README.md を参照**

### 各種ツールの使い方
本システムでは、学習によってHeightmapから着地可能領域、着地高さ姿勢画像の変換を行っている。
学習に用いる地形データはランダムに生成しており、教師データは３次元凸包計算により生成している。
学習のさせ方は以下の通り。(すべてvisionワークスペース)
いろいろサボっているのでrosrunでは動かないと思う。

```bash
#学習データ作成
$ roscd terrain_recognition/scripts
$ ./rm_generate_terrains.sh #生成済みの学習用データを消す。

#地形データ＆教師データ生成。引数は生成データ数で、2000ぐらいがよい
$ #./generate 生成数
$ ./generate_terrain.py 2000

#着地可能領域学習。データ数は200000程度、epoch数は5~10程度で何回か繰り返す。３つ目の引数は、f:学習するかどうか、w:既存の重みをロードするかどうか、v:デバッグ用出力を表示するかどうか、を表す。
$ #./real_steppable_region_learning.py 生成データ数 epoch数 f/w/v
$ ./real_steppable_region_learning.py 200000 10 fv

#着地高さ姿勢学習。同じくデータ数は200000程度、epoch数は10程度を何回か繰り返す。
$ #./real_pose_height_learning.py 生成データ数 epoch数 f/w/v
$ ./real_pose_height_learning.py 200000 10 fv

#確認＆地形データ追加用コマンド。特定の点をクリックすると、rvizに着地高さ姿勢と、着地可能性の認識結果（赤or緑）が表示される。その他、手動アノテーションしたデータを追加するときにも使う。追加されたデータはファイル名＋日付の名前で保存される。
$ ./save_surface 保存ファイル名
$ #点選択+oを押すことで着地可能とアノテーション、xを押すことで着地不可能とアノテーションしてデータを追加
$ #ドラッグで範囲を選択し、Enterを押すことでノイズ画像を取得
$ #deleteやbackspaceで選択解除
```


※今後更新予定・・・
