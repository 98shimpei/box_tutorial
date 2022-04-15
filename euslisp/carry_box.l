(load "package://push-recovery/push-recovery-foot-guided.l")
(robots-init "jaxon_red")
(start-footguided-modification)
(objects (list *robot*))

(send *robot* :fix-leg-to-coords (make-coords))
(send *robot* :reset-manip-pose)
(send *ri* :angle-vector (send *robot* :angle-vector) 3000)
(send *ri* :wait-interpolation)
(print "press enter to put box")
(read-line)
(send *robot* :rarm :inverse-kinematics (make-coords :pos #f(300 -400 1130) :rpy (float-vector 0 0 (deg2rad 90))))
(send *robot* :larm :inverse-kinematics (make-coords :pos #f(300 400 1130) :rpy (float-vector 0 0 (deg2rad -90))))
(send *ri* :angle-vector (send *robot* :angle-vector) 7000)
(send *ri* :wait-interpolation)
(send *robot* :arms :move-end-pos #f(300 0 0))
(send *ri* :angle-vector (send *robot* :angle-vector) 5000)
(send *ri* :wait-interpolation)
(send *ri* :remove-force-sensor-offset-rmfo-arms)
(send *ri* :start-impedance :arms :K-r 200.0 :D-r 300.0  :M-r 1
                                  :K-p 500.0 :D-p 1000.0 :M-p 5)
(send *robot* :arms :move-end-pos #f(0 0 -170))
(send *ri* :angle-vector (send *robot* :angle-vector) 3000)
(send *ri* :wait-interpolation)
(send *ri* :set-ref-forces
      (list
       (float-vector 0 0 0)
       (float-vector 0 0 0)
       (float-vector 0 -100  0) ;;rarm -260  mg/2
       (float-vector 0 100 0) ;;larm -285
       )
       3000)
(unix:sleep 5)
(send *ri* :set-ref-forces
      (list
       (float-vector 0 0 0)
       (float-vector 0 0 0)
       (float-vector 0 -100 -12) ;;rarm -260  mg/2
       (float-vector 0 100  -12) ;;larm -285
       )
       5000)
(unix:sleep 5)
(send *robot* :arms :move-end-pos #f(0 0 200) :world)
(send *ri* :angle-vector (send *robot* :angle-vector) 5000)
(send *ri* :wait-interpolation)
