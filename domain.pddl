(define (domain construction_site_monitoring)
  (:requirements :strips :typing :fluents :negative-preconditions)

  (:types
    robot location tool configuration
  )

  (:predicates
    (at ?r - robot ?l - location)
    (inspection_required ?r - robot ?l - location)
    (connected ?l1 ?l2 - location)
    (stabilized ?r - robot)
    (manipulator_deployed ?r - robot)
    (end_effector_positioned ?r - robot ?c - configuration)
    (manipulator_retracted ?r - robot)
    (inspection_initiated ?r - robot ?l - location)
    (tool_for_worker_activity ?t - tool)
    (tool_for_structural ?t - tool)
    (tool_for_temperature ?t - tool)
    (structural_integrity_performed ?r - robot)
    (worker_activity_performed ?r - robot)
    (temperature_variation_performed ?r - robot)
    (data_collected ?r - robot)
    (data_reported ?r - robot)
    (bim_updated ?r - robot)
    (inspection_completed ?r - robot ?l - location)
    (additional_reading_required ?r - robot)
    (additional_reading_performed ?r - robot)
    (session_closed ?r - robot)
  )

  (:functions
    (count ?r - robot) 
    (target_count ?r - robot)
  )

  (:action navigate
    :parameters (?r - robot ?l1 ?l2 - location)
    :precondition (and (at ?r ?l1) (connected ?l1 ?l2) (manipulator_retracted ?r))
    :effect (and (at ?r ?l2) (not (at ?r ?l1)))
  )
  
  (:action inspection_initiation
    :parameters (?r - robot ?l - location)
    :precondition (and (at ?r ?l) (inspection_required ?r ?l))
    :effect (inspection_initiated ?r ?l)
  )
  
  (:action stabilize
    :parameters (?r - robot ?l - location)
    :precondition (inspection_initiated ?r ?l)
    :effect (stabilized ?r)
  )
  
  (:action deploy_manipulator
    :parameters (?r - robot)
    :precondition (and (stabilized ?r) (manipulator_retracted ?r))
    :effect (and (manipulator_deployed ?r) (not (manipulator_retracted ?r)))
  )
  
  (:action position_end_effector
    :parameters (?r - robot ?c - configuration)
    :precondition (manipulator_deployed ?r)
    :effect (end_effector_positioned ?r ?c)
  )
  
  (:action retract_manipulator
    :parameters (?r - robot)
    :precondition (and (manipulator_deployed ?r) (data_reported ?r))
    :effect (and (not (manipulator_deployed ?r)) (manipulator_retracted ?r))
  )
  
  (:action structural_integrity_analysis
    :parameters (?r - robot ?t - tool ?c - configuration)
    :precondition (and (end_effector_positioned ?r ?c) (tool_for_structural ?t))
    :effect (structural_integrity_performed ?r)
  )
  
  (:action worker_activity_analysis
    :parameters (?r - robot ?t - tool ?c - configuration)
    :precondition (and (end_effector_positioned ?r ?c) (tool_for_worker_activity ?t))
    :effect (worker_activity_performed ?r)
  )

  (:action temperature_variation_analysis
    :parameters (?r - robot ?t - tool ?c - configuration)
    :precondition (and (end_effector_positioned ?r ?c) (tool_for_temperature ?t))
    :effect (temperature_variation_performed ?r)
  )

  (:action collect_data
    :parameters (?r - robot)
    :precondition (and (temperature_variation_performed ?r) (worker_activity_performed ?r) (structural_integrity_performed ?r))
    :effect (data_collected ?r)
  )

  (:action update_bim
    :parameters (?r - robot)
    :precondition (data_collected ?r)
    :effect (bim_updated ?r)
  )
  
  (:action decision_making
    :parameters (?r - robot)
    :precondition (and (bim_updated ?r) (< (count ?r) (target_count ?r)))
    :effect (additional_reading_required ?r)
  )

  (:action additional_reading
    :parameters (?r - robot)
    :precondition (additional_reading_required ?r)
    :effect (and (additional_reading_performed ?r) (increase (count ?r) 1))
  )
  
    (:action report_data
    :parameters (?r - robot)
    :precondition (and (bim_updated ?r) (>= (count ?r) (target_count ?r)))
    :effect (data_reported ?r)
  )

  (:action inspection_completion
    :parameters (?r - robot ?l - location)
    :precondition (and (at ?r ?l) (data_reported ?r) (manipulator_retracted ?r))
    :effect (inspection_completed ?r ?l)
  )
)
