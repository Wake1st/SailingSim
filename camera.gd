class_name Camera
extends Node3D

@export var rotationRate: float = 2.2


func _physics_process(delta):
	var input = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	
	if input != 0:
		rotate_y(input * delta * rotationRate)
