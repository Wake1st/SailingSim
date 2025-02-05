class_name Boat
extends Node3D

const MAX_RUDDER_ANGLE: float = PI/4

@export var rudderRateOfChange: float = 1.4
@export var sailRateOfChange: float = 1.8

@onready var rudderRoot = %RudderRoot
@onready var sailRoot = %SailRoot

var currentRudderAngle: float = 0
var currentSailVector: Vector2 = Vector2.UP


func _physics_process(delta):
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
