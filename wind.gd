class_name Wind
extends Node3D

@export_range(-1,1) var directionX: float
@export_range(-1,1) var directionZ: float
@export var magnitude: float = 10.0


func get_wind() -> Vector3:
	return Vector3(directionX, 0.0, directionZ) * magnitude
