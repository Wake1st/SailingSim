class_name Boat
extends Node3D

const MAX_RUDDER_ANGLE: float = PI/4
const WIND_LOSS_ANGLE: float = PI*3/4

@export_category("Control Surfaces")
@export var rudderRateOfChange: float = 1.4
@export var sailRateOfChange: float = 1.8

@export_category("Kinematics")
@export var rudderEfficiency: float = 0.4
@export var sailEfficiency: float = 1.2

@onready var rudderRoot = %RudderRoot
@onready var sailRoot = %SailRoot

var currentRudderAngle: float = 0
var currentSailVector: Vector2 = Vector2.UP

var windProjection: float


func calculate_wind_projection(wind: Vector3) -> void:
	var clampedAngle = clampf(wind.angle_to(-basis.z), 0, WIND_LOSS_ANGLE)
	var windEffectiveness = (WIND_LOSS_ANGLE - clampedAngle) / WIND_LOSS_ANGLE
	var directProjection = -wind.project(sailRoot.global_basis.x).length()
	windProjection = directProjection * windEffectiveness


func _physics_process(delta: float) -> void:
	input_processing(delta)
	kinematics(delta)

#region Inputs
func input_processing(delta: float) -> void:
	var sailInput = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var rudderInput = Input.get_action_strength("rudder_right") - Input.get_action_strength("rudder_left")
	
	if sailInput != Vector2.ZERO:
		rotate_sail(delta * sailRateOfChange, sailInput)
	
	if rudderInput != 0.0:
		rotate_rudder(rudderInput * delta * rudderRateOfChange)


func rotate_rudder(deltaAngle: float) -> void:
	var newAngle = clampf(currentRudderAngle + deltaAngle, -MAX_RUDDER_ANGLE, MAX_RUDDER_ANGLE)
	if currentRudderAngle != newAngle:
		rudderRoot.rotate_y(deltaAngle)
		
		# store the updated angle
		currentRudderAngle = newAngle


func rotate_sail(delta: float, inputVector: Vector2) -> void:
	if currentSailVector != inputVector:
		var targetSailAngle = currentSailVector.angle_to(inputVector)
		var deltaAngle = targetSailAngle * delta
		sailRoot.rotate_y(deltaAngle)
		
		# store the updated angle
		currentSailVector = currentSailVector.rotated(deltaAngle)
#endregion

#region kinematics
func kinematics(delta: float) -> void:
	# rotate boat
	rotate_y(-currentRudderAngle * delta * rudderEfficiency)
	
	# move forward
	translate_object_local(Vector3(0.0, 0.0, windProjection) * delta * sailEfficiency)
#endregion
