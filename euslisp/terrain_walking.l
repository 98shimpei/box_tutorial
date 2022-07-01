(load "package://push-recovery/push-recovery-foot-guided.l")
(load "package://control_tools/play-hrpsysfile.l")
(robots-init "jaxon_red")
(start-footguided-modification)

(send *ri* :set-gait-generator-param
           :modify-footsteps nil       ;;着地位置補正を行うと、着地位置がずれてしまうので、環境認識を行わない場合は切る
           :default-step-height 0.15   ;;足上げ高さ
           :default-step-time 1.5      ;;歩行速度
           :default-double-support-ratio 0.4) ;;両足支持期間の割合

(lower-waist) ;;腰を下げる

(send *ri* :go-pos 1.5 0 0) ;;段差の前まで進む

(send *ri* :set-foot-steps
  (list (make-coords :coords (send *robot* :rleg :end-coords :copy-worldcoords) :name :rleg)
        (make-coords :coords (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 130 0 0  )) :name :lleg)
        (make-coords :coords (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 130 0 0  )) :name :rleg)
        (make-coords :coords (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 370 0 100)) :name :lleg)
        (make-coords :coords (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 370 0 100)) :name :rleg)
        (make-coords :coords (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 500 0 100)) :name :lleg)
        (make-coords :coords (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 630 0 100)) :name :rleg)
        (make-coords :coords (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 870 0 200)) :name :lleg)
        (make-coords :coords (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 870 0 200)) :name :rleg)
        (make-coords :coords (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 1000 0 200)) :name :lleg)
        (make-coords :coords (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 1150 0 200)) :name :rleg)
        (make-coords :coords (send (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 1390 0 171)) :rotate (deg2rad -15) :y) :name :lleg)
        (make-coords :coords (send (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 1500 0 200)) :rotate (deg2rad -15) :y) :name :rleg)
        (make-coords :coords (send (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 1630 0 233)) :rotate (deg2rad -15) :y) :name :lleg)
        (make-coords :coords (send (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 1870 0 233)) :rotate (deg2rad 15) :y) :name :rleg)
        (make-coords :coords (send (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 2000 0 200)) :rotate (deg2rad 15) :y) :name :lleg)
        (make-coords :coords (send (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 2130 0 166)) :rotate (deg2rad 15) :y) :name :rleg)
        (make-coords :coords (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 2370 0 100)) :name :lleg)
        (make-coords :coords (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 2500 0 100)) :name :rleg)
        (make-coords :coords (send (send *robot* :lleg :end-coords :copy-worldcoords) :translate (float-vector 2500 0 100)) :name :lleg)
        (make-coords :coords (send (send *robot* :rleg :end-coords :copy-worldcoords) :translate (float-vector 2500 0 100)) :name :rleg)
        ))
