(load "package://push-recovery/push-recovery-foot-guided.l")
(robots-init "jaxon_red")
(start-footguided-modification)

(send *ri* :set-gait-generator-param
           :default-step-time 1.2)      ;;歩行速度

(lower-waist 100) ;;腰を下げる

(send *ri* :go-velocity 1 0 0)
