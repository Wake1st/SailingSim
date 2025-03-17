class_name AngleOfAttackCurve
extends Path2D

const MAGNIFIER: float = -0.0182
const RAD_TO_DEGREES: float = 180/PI

@onready var follower = $Follower


func get_sail_force(angle: float) -> float:
	var angle_degrees = angle * RAD_TO_DEGREES
	var weight = inverse_lerp(0, 90, angle_degrees)
	follower.progress_ratio = weight
	return follower.position.y * MAGNIFIER
