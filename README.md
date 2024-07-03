
# AIRO II - Assignment June 2024

In the context of a modern construction site, autonomous robots are tasked with monitoring the execution of work to estimate its advancements, and to ensure safety and efficiency. Equipped with various sensors and tools, these robots must navigate the site, inspect ongoing tasks, and report any discrepancies or hazards.

**Author:** Nima Abaeian - 5967579  
**Professor:** Fulvio Mastrogiovanni  
**Course:** ARTIFICIAL INTELLIGENCE FOR ROBOTICS II  
**University:** Università degli studi di Genova, DIBRIS  
**Department:** Department of Computer Science and Technology, Bioengineering, Robotics and System Engineering  

## Plan Found Using OPTIC Solver

### Robot1 Performing Inspection Individually in Room E
**Plan found with metric 0.017; states evaluated so far: 21; states pruned based on pre-heuristic cost lower bound: 0; time 0.090.**

- 0.000: (navigate robot1 a b) [0.001]
- 0.001: (navigate robot1 b c) [0.001]
- 0.002: (navigate robot1 c d) [0.001]
- 0.003: (navigate robot1 d e) [0.001]
- 0.004: (inspection\_initiation robot1 e) [0.001]
- 0.005: (stabilize robot1 e) [0.001]
- 0.006: (deploy\_manipulator robot1) [0.001]
- 0.007: (position\_end\_effector robot1 configuration1) [0.001]
- 0.008: (temperature\_variation\_analysis robot1 thermal configuration1) [0.001]
- 0.008: (worker\_activity\_analysis robot1 camera configuration1) [0.001]
- 0.008: (structural\_integrity\_analysis robot1 lidar configuration1) [0.001]
- 0.009: (collect\_data robot1) [0.001]
- 0.010: (update\_bim robot1) [0.001]
- 0.011: (decision\_making robot1) [0.001]
- 0.012: (additional\_reading robot1) [0.001]
- 0.013: (additional\_reading robot1) [0.001]
- 0.014: (additional\_reading robot1) [0.001]
- 0.015: (report\_data robot1) [0.001]
- 0.016: (retract\_manipulator robot1) [0.001]
- 0.017: (inspection\_completion robot1 e) [0.001]

### Robot1 and Robot2 Performing Inspection in Room E and Room G Respectively
**Plan found with metric 0.019; states evaluated so far: 55; states pruned based on pre-heuristic cost lower bound: 0; time 0.100.**

- 0.000: (navigate robot2 a b) [0.001]
- 0.000: (navigate robot1 a b) [0.001]
- 0.001: (navigate robot2 b c) [0.001]
- 0.001: (navigate robot1 b c) [0.001]
- 0.002: (navigate robot2 c d) [0.001]
- 0.002: (navigate robot1 c d) [0.001]
- 0.003: (navigate robot2 d e) [0.001]
- 0.003: (navigate robot1 d e) [0.001]
- 0.004: (inspection\_initiation robot1 e) [0.001]
- 0.004: (navigate robot2 e f) [0.001]
- 0.005: (stabilize robot1 e) [0.001]
- 0.005: (navigate robot2 f g) [0.001]
- 0.006: (inspection\_initiation robot2 g) [0.001]
- 0.006: (deploy\_manipulator robot1) [0.001]
- 0.007: (stabilize robot2 g) [0.001]
- 0.007: (position\_end\_effector robot1 configuration1) [0.001]
- 0.008: (temperature\_variation\_analysis robot1 thermal configuration1) [0.001]
- 0.008: (worker\_activity\_analysis robot1 camera configuration1) [0.001]
- 0.008: (structural\_integrity\_analysis robot1 lidar configuration1) [0.001]
- 0.008: (deploy\_manipulator robot2) [0.001]
- 0.009: (position\_end\_effector robot2 configuration1) [0.001]
- 0.009: (collect\_data robot1) [0.001]
- 0.010: (temperature\_variation\_analysis robot2 thermal configuration1) [0.001]
- 0.010: (worker\_activity\_analysis robot2 camera configuration1) [0.001]
- 0.010: (update\_bim robot1) [0.001]
- 0.010: (structural\_integrity\_analysis robot2 lidar configuration1) [0.001]
- 0.011: (decision\_making robot1) [0.001]
- 0.011: (collect\_data robot2) [0.001]
- 0.012: (additional\_reading robot1) [0.001]
- 0.012: (update\_bim robot2) [0.001]
- 0.013: (decision\_making robot2) [0.001]
- 0.013: (additional\_reading robot1) [0.001]
- 0.014: (additional\_reading robot1) [0.001]
- 0.014: (additional\_reading robot2) [0.001]
- 0.015: (report\_data robot1) [0.001]
- 0.015: (additional\_reading robot2) [0.001]
- 0.016: (retract\_manipulator robot1) [0.001]
- 0.016: (additional\_reading robot2) [0.001]
- 0.017: (inspection\_completion robot1 e) [0.001]
- 0.017: (report\_data robot2) [0.001]
- 0.018: (retract\_manipulator robot2) [0.001]
- 0.019: (inspection\_completion robot2 g) [0.001]

* All goal deadlines now no later than 0.019.

## Detailed Breakdown of Requirements Addressed in the Code

### 1. Navigation and Positioning

#### Robots know how to move between various locations and position themselves:

##### 1a. Move between various locations (topological map):
**Locations and Connections:** In `Problem.txt`, locations A, B, C, D, E, F, G, H are defined as objects of type `location`. Connections between these locations are represented using the `connected` predicate:
```
(connected A B)
(connected B C)
(connected C D)
(connected D E)
(connected E F)
(connected F G)
(connected G H)
(connected H A)
```
Navigation Action: The navigate action in Domain.txt allows robots to move between connected locations:

```
(:action navigate
  :parameters (?r - robot ?l1 ?l2 - location)
  :precondition (and (at ?r ?l1) (connected ?l1 ?l2) (manipulator_retracted ?r))
  :effect (and (at ?r ?l2) (not (at ?r ?l1)))
)
```
1b. Position firmly on the ground:
Stabilization Action: The stabilize action ensures that a robot stabilizes once it reaches the location and initiates inspection:

```
(:action stabilize
  :parameters (?r - robot ?l - location)
  :precondition (inspection_initiated ?r ?l)
  :effect (stabilized ?r)
)
```
2. Inspection
Robots know how to conduct inspections:
2a. Extend a manipulator arm:
Deploy Manipulator: The deploy_manipulator action handles extending the manipulator arm:
```
(:action deploy_manipulator
  :parameters (?r - robot)
  :precondition (and (stabilized ?r) (manipulator_retracted ?r))
  :effect (and (manipulator_deployed ?r) (not (manipulator_retracted ?r)))
)
```
2b. Position the manipulator’s end-effector:
Position End-Effector: The position_end_effector action positions the end-effector in one of the specified configurations:
```
(:action position_end_effector
  :parameters (?r - robot ?c - configuration)
  :precondition (manipulator_deployed ?r)
  :effect (end_effector_positioned ?r ?c)
)
```
2c. Use sensors on the manipulator’s end-effector:
Inspection Tools and Actions: The actions for using sensors include structural_integrity_analysis, worker_activity_analysis, and temperature_variation_analysis:

```
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
```
2d. Retract the manipulator:
Retract Manipulator: The retract_manipulator action handles retraction of the manipulator arm:
```
(:action retract_manipulator
  :parameters (?r - robot)
  :precondition (and (manipulator_deployed ?r) (data_reported ?r))
  :effect (and (not (manipulator_deployed ?r)) (manipulator_retracted ?r))
)
```
3. Data Collection
Robots know how to collect data:
3a. Activate and deactivate each tool:
Tool Activation: Implicitly modeled within the analysis actions.

3b. Acquire data from each tool:
Data Collection: The collect_data action ensures data is collected after all analyses are performed:
```
(:action collect_data
  :parameters (?r - robot)
  :precondition (and (temperature_variation_performed ?r) (worker_activity_performed ?r) (structural_integrity_performed ?r))
  :effect (data_collected ?r)
)
```
4. Data Processing
   
Robots know how to process data:

4a. Perform structural integrity analysis:
Structural Integrity Analysis: Performed by structural_integrity_analysis action.

4b. Perform worker activity analysis:
Worker Activity Analysis: Performed by worker_activity_analysis action.

4c. Perform temperature variation analysis:
Temperature Variation Analysis: Performed by temperature_variation_analysis action.

5. Decision Making
Robots know how to make decisions:
5a. Determine inspection frequency and tool usage:
Decision Making: The decision_making and additional_reading actions ensure additional inspections are performed if required:

```
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
```
6. Reporting
   
Robots know how to report data:

6a. Format data and update BIM:
Update BIM: The update_bim action formats and updates the BIM database:

```
(:action update_bim
  :parameters (?r - robot)
  :precondition (data_collected ?r)
  :effect (bim_updated ?r)
)
```
6b. Close the session:
Close Session: The inspection_completion action finalizes the inspection:

```
(:action inspection_completion
  :parameters (?r - robot ?l - location)
  :precondition (and (at ?r ?l) (data_reported ?r) (manipulator_retracted ?r))
  :effect (inspection_completed ?r ?l)
)
```
