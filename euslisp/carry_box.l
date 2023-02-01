;; 最初のおまじない群
(load "package://box_tutorial/euslisp/simple_start.l");; 起動スクリプト呼び出し
(objects (list *robot*)) ;;irt-viewerにロボットを表示
(send *robot* :fix-leg-to-coords (make-coords)) ;; *robot*の座標系を両足平の真ん中に移動

;; ロボットの姿勢の変更方法
;; *robot* -> ロボットモデルのオブジェクト。実際に動くロボットではなく、複製したマネキンみたいなイメージ？
;; *ri* -> Robot Interface の略。実際のロボットに司令を送ったり状態を受け取ったりする。
(send *robot* :reset-manip-pose) ;; *robot*の各関節角度を、reset-manip-poseの状態に変更。
(send *ri* :angle-vector (send *robot* :angle-vector) 3000) ;; 実ロボットに、*robot*の関節角度を送る。最後の引数は遷移時間。
(send *ri* :wait-interpolation) ;; ロボットが動き終わるまで待つ。（これを入れないと、ロボットが動いている途中で次の処理に移ってしまう。）

(print (send *robot* :rarm :shoulder-p :joint-angle)) ;;右手の肩ピッチ関節の角度を表示
(send *robot* :rarm :shoulder-p :joint-angle 65) ;;同関節の角度を変更。一つの関節だけ変える場合は:joint-angle
(send *ri* :angle-vector (send *robot* :angle-vector)) ;;時間は指定しなくても良い（デフォルトの時間が使われる）
(send *ri* :wait-interpolation)

(print (send *robot* :head :angle-vector)) ;;首の２関節の角度を表示
(send *robot* :head :angle-vector #f(0 10)) ;;関節グループ内全部の関節を指定する場合は:angle-vector
(send *ri* :angle-vector (send *robot* :angle-vector))
(send *ri* :wait-interpolation)

;; 逆運動学(Inverse Kinematics)を用いたロボットの姿勢の司令方法
(print "press enter to put box") ;;ただのプリント文
(read-line) ;;キーボード入力が来るまで待つ
(send *robot* :rarm :inverse-kinematics (make-coords :pos #f(300 -400 1130) :rpy (float-vector 0 0 (deg2rad 0)))) ;;(make-coords)で生成した位置姿勢に右手が来るように、逆運動学を解いて関節角度を求める。今回は変えていないが、角度も変えたい場合はradで設定するかdeg2rad関数を用いてdegreeで設定
(send *robot* :larm :inverse-kinematics (make-coords :pos #f(300 400 1130) :rpy (float-vector 0 0 (deg2rad 0)))) ;;左手も同様。
(send *ri* :angle-vector (send *robot* :angle-vector) 7000) ;;実ロボットに司令を出す。
(send *ri* :wait-interpolation)

(send *robot* :arms :move-end-pos #f(300 0 -100)) ;;現在の位置から手先の移動量を指定する方法。デフォルトでは手先座標系。
(send *ri* :angle-vector (send *robot* :angle-vector) 5000)
(send *ri* :wait-interpolation)

;; インピーダンス制御の設定
(send *ri* :remove-force-sensor-offset-rmfo-arms) ;;手先力センサのオフセットを除去。
(send *ri* :set-impedance-controller-param :arms :K-r 200.0 :D-r 300.0  :M-r 1
                                                 :K-p 500.0 :D-p 1000.0 :M-p 5) ;;インピーダンス制御の設定。K(バネ)D(ダンパ)M(慣性)、　r(回転)、p(並進)
(send *ri* :start-impedance :arms) ;;インピーダンス制御開始

;;箱を持つ
(send *robot* :rarm :move-end-pos #f(0 180 0))
(send *robot* :larm :move-end-pos #f(0 -180 0))
(send *ri* :angle-vector (send *robot* :angle-vector) 3000)
(send *ri* :wait-interpolation)

;;かかる参照力の設定
;;インピーダンス制御を入れている場合、設定した反力を受けるまで力をかけるようになる。
;;まずは挟む力をかける
(send *ri* :set-ref-forces
      (list
       (float-vector 0 0 0) ;;rleg
       (float-vector 0 0 0) ;;lleg
       (float-vector 0 -100  0) ;;rarm (x, y, z) 単位はニュートン
       (float-vector 0 100   0) ;;larm
       )
       3000)
(unix:sleep 5) ;;指定した時間(秒)処理を止める

;;上に持ち上げる力をかける
(send *ri* :set-ref-forces
      (list
       (float-vector 0 0 0)
       (float-vector 0 0 0)
       (float-vector 0 -100 -5) ;;rarm
       (float-vector 0 100  -5) ;;larm
       )
       5000)
(unix:sleep 5)

;;箱を持ち上げる
(send *robot* :arms :move-end-pos #f(0 0 200))
(send *ri* :angle-vector (send *robot* :angle-vector) 5000)
(send *ri* :wait-interpolation)
