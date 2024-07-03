(define (problem construction_site_monitoring_scenario)
  (:domain construction_site_monitoring)
  (:objects
    Robot1 Robot2 - robot
    A B C D E F G H - location
    camera lidar thermal - tool
    Configuration1 Configuration2 Configuration3 - configuration
  )
  (:init
    (at Robot1 A)
    (at Robot2 A)
    (connected A B)
    (connected B C)
    (connected C D)
    (connected D E)
    (connected E F)
    (connected F G)
    (connected G H)
    (connected H A)
    (tool_for_worker_activity camera)
    (tool_for_structural lidar)
    (tool_for_temperature thermal)
    (manipulator_retracted Robot1)
    (manipulator_retracted Robot2)
    (inspection_required Robot1 E)
    (inspection_required Robot2 G)
    (= (count Robot1) 0)
    (= (count Robot2) 0)
    (= (target_count Robot1) 3)
    (= (target_count Robot2) 3)
  )
  (:goal
    (and
      (inspection_completed Robot1 E)
    )
  )
)
