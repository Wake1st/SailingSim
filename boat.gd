class_name Boat
extends RigidBody3D

const MAX_RUDDER_ANGLE: float = PI/4
const MAX_SAIL_ANGLE: float = PI/2
const WIND_LOSS_ANGLE: float = PI*5/6
const RUDDER_DAMPED_FLOOR: float = 0.000001

@export_category("Control Surfaces")
@export var rudderRateOfChange: float = 1.4
@export var sailRateOfChange: float = 1.8
@export var rudderDampening: float = 0.8

@export_category("Kinematics")
@export var rudderEfficiency: float = 48
@export var sailEfficiency: float = 64

@onready var rudderRoot = %RudderRoot
@onready var sailRoot = %SailRoot
@onready var sailMesh = %SailMesh

var currentRudderAngle: float = 0
var currentSailAngle: float = 0

@onready var windCurve = $WindCurve
var windProjection: float

#region External Methods
func calculate_wind_projection(wind: Vector3) -> void:
	var angle = -wind.angle_to(basis.z)
	windProjection = windCurve.get_max_speed(-angle) * wind.length()
	print("angle: %s\trelative wind: %s" % [-angle, windProjection])
	
	sailMesh.distort_sail(windProjection)
#endregion

#region Included Methods
func _physics_process(delta: float) -> void:
	input_processing(delta)
	kinematics(delta)
#endregion

#region Surface Controlling
func input_processing(delta: float) -> void:
	var sailInput = Input.get_action_strength("sail_right") - Input.get_action_strength("sail_left")
	var rudderInput = Input.get_action_strength("rudder_right") - Input.get_action_strength("rudder_left")
	
	if sailInput != 0.0:
		rotate_sail(sailInput * delta * sailRateOfChange)
	
	if rudderInput != 0.0:
		rotate_rudder(rudderInput * delta * rudderRateOfChange)
	else:
		rotate_rudder(-currentRudderAngle * delta * rudderDampening)


func rotate_rudder(deltaAngle: float) -> void:
	var updatedAngle = currentRudderAngle + deltaAngle
	if abs(updatedAngle) < RUDDER_DAMPED_FLOOR:
		currentRudderAngle = 0
		rudderRoot.rotation = Vector3.ZERO
	else:
		var clampedAngle = clampf(updatedAngle, -MAX_RUDDER_ANGLE, MAX_RUDDER_ANGLE)
		if currentRudderAngle != clampedAngle:
			rudderRoot.rotate_y(deltaAngle)
			
			# store the updated angle
			currentRudderAngle = clampedAngle


func rotate_sail(deltaAngle: float) -> void:
	var clampedAngle = clampf(currentSailAngle + deltaAngle, -MAX_SAIL_ANGLE, MAX_SAIL_ANGLE)
	if currentSailAngle != clampedAngle:
		sailRoot.rotate_y(deltaAngle)
		
		# store the updated angle
		currentSailAngle = clampedAngle
#endregion

#region Kinematics
func kinematics(delta: float) -> void:
	# rotate boat
	apply_torque(Vector3.DOWN * currentRudderAngle * delta * rudderEfficiency)
	
	# move forward
	apply_central_force(-global_basis.z * windProjection * delta * sailEfficiency)
#endregion
