class_name Boat
extends RigidBody3D

const MAX_RUDDER_ANGLE: float = PI/4
const MAX_SAIL_ANGLE: float = PI/2
const WIND_LOSS_ANGLE: float = PI*5/6

@export_category("Control Surfaces")
@export var rudderRateOfChange: float = 1.4
@export var sailRateOfChange: float = 1.8

@export_category("Kinematics")
@export var rudderEfficiency: float = 48
@export var sailEfficiency: float = 64

@onready var rudderRoot = %RudderRoot
@onready var sailRoot = %SailRoot

var currentRudderAngle: float = 0
var currentSailAngle: float = 0

var windProjection: float

#region External Methods
func calculate_wind_projection(wind: Vector3) -> void:
	var clampedAngle = clampf(wind.angle_to(-basis.z), 0, WIND_LOSS_ANGLE)
	var windEffectiveness = (WIND_LOSS_ANGLE - clampedAngle) / WIND_LOSS_ANGLE
	var directProjection = wind.project(sailRoot.global_basis.x).length()
	windProjection = directProjection * windEffectiveness
#endregion

func _physics_process(delta: float) -> void:
	input_processing(delta)
	kinematics(delta)

#region Input Handling
func input_processing(delta: float) -> void:
	var sailInput = Input.get_action_strength("sail_right") - Input.get_action_strength("sail_left")
	var rudderInput = Input.get_action_strength("rudder_right") - Input.get_action_strength("rudder_left")
	
	if sailInput != 0.0:
		rotate_sail(sailInput * delta * sailRateOfChange)
	
	if rudderInput != 0.0:
		rotate_rudder(rudderInput * delta * rudderRateOfChange)


func rotate_rudder(deltaAngle: float) -> void:
	var newAngle = clampf(currentRudderAngle + deltaAngle, -MAX_RUDDER_ANGLE, MAX_RUDDER_ANGLE)
	if currentRudderAngle != newAngle:
		rudderRoot.rotate_y(deltaAngle)
		
		# store the updated angle
		currentRudderAngle = newAngle


func rotate_sail(deltaAngle: float) -> void:
	var newAngle = clampf(currentSailAngle + deltaAngle, -MAX_SAIL_ANGLE, MAX_SAIL_ANGLE)
	if currentSailAngle != newAngle:
		sailRoot.rotate_y(deltaAngle)
		
		# store the updated angle
		currentSailAngle = newAngle
#endregion

#region kinematics
func kinematics(delta: float) -> void:
	# rotate boat
	apply_torque(Vector3.DOWN * currentRudderAngle * delta * rudderEfficiency)
	
	# move forward
	apply_central_force(global_basis * Vector3.FORWARD * windProjection * delta * sailEfficiency)
#endregion
