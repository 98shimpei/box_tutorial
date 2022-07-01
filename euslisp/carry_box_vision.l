(load "package://push-recovery/push-recovery-foot-guided.l")
(load "package://control_tools/play-hrpsysfile.l")
(robots-init "jaxon_red")
(start-footguided-modification)

(setq *tfl* (instance ros::transform-listener :init)) ;; tfを使う準備
(setq target-frame "ar_marker_1") ;; ターゲットのフレーム名を設定

(send *robot* :reset-manip-pose) ;; 手先や首を動かしておく
(send *robot* :head :angle-vector #f(0 5))
(send *ri* :angle-vector (send *robot* :angle-vector))
(send *ri* :wait-interpolation)


(while (not (send *tfl* :wait-for-transform "BODY" target-frame (ros::time 0) 3)) (progn (print "tf is not connected") (unix:sleep 1))) ;; BODYからtarget-frameまでのtfがつながるまで待つ
(setq body->target-coords (send *tfl* :lookup-transform "BODY" target-frame (ros::time 0))) ;;BODYからtarget-frameまでの変換行列を得る
(setq box-pose (send (send (send *robot* :links :body :copy-worldcoords) :transform body->target-coords) :translate #f(0 0 -150))) ;; 箱の位置姿勢を得る（マーカーの位置から箱の位置への変換も行う）
(setq rhand-pose (send (send box-pose :copy-worldcoords) :transform (make-coords :pos #f(200 50 -50) :rpy (float-vector (deg2rad 180) (deg2rad 90) 0)))) ;; 右手の把持位置の位置姿勢を得る
(setq lhand-pose (send (send box-pose :copy-worldcoords) :transform (make-coords :pos #f(-200  50 -50) :rpy (float-vector 0 (deg2rad 90) 0)))) ;; 左手の把持位置の位置姿勢を得る


(objects (list *robot* box-pose rhand-pose lhand-pose))

;; 箱の手前に一度手を持っていく
(send *robot* :rarm :inverse-kinematics (send (send rhand-pose :copy-worldcoords) :translate #f(-300 0 -150)))
(send *robot* :larm :inverse-kinematics (send (send lhand-pose :copy-worldcoords) :translate #f(-300 0 -150)))
(send *ri* :angle-vector (send *robot* :angle-vector) 5000)
(send *ri* :wait-interpolation)

;; 箱を挟む前の位置に手を持っていく
(send *robot* :rarm :inverse-kinematics (send (send rhand-pose :copy-worldcoords) :translate #f(0 0 -150)))
(send *robot* :larm :inverse-kinematics (send (send lhand-pose :copy-worldcoords) :translate #f(0 0 -150)))
(send *ri* :angle-vector (send *robot* :angle-vector) 5000)
(send *ri* :wait-interpolation)

;; インピーダンス制御の設定
(send *ri* :remove-force-sensor-offset-rmfo-arms) ;;手先力センサのオフセットを除去。
(send *ri* :start-impedance :arms :K-r 200.0 :D-r 300.0  :M-r 1
                                  :K-p 500.0 :D-p 1000.0 :M-p 5)

;; 箱を挟む
(send *robot* :rarm :inverse-kinematics rhand-pose)
(send *robot* :larm :inverse-kinematics lhand-pose)
(send *ri* :angle-vector (send *robot* :angle-vector) 5000)
(send *ri* :wait-interpolation)

;;挟む力をかける
(send *ri* :set-ref-forces
      (list
       (float-vector 0 0 0) ;;rleg
       (float-vector 0 0 0) ;;lleg
       (float-vector 0 -200  -5) ;;rarm (x, y, z) 単位はニュートン
       (float-vector 0 200   -5) ;;larm
       )
       3000)
(unix:sleep 5)

;; 箱を持ち上げる
(send *robot* :arms :move-end-pos #f(0 0 100) :world)
(send *ri* :angle-vector (send *robot* :angle-vector))
(send *ri* :wait-interpolation)
