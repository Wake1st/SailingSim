@tool
class_name WindCurve
extends Path2D

const MAGNIFIER: float = 100
const WIND_MIN_ANGLE: float = PI/6
const WIND_MAX_ANGLE: float = 2*PI

@onready var line = $Line2D
@onready var speed = $Speed


func clamp_wind_angle(angle: float) -> float:
	if angle < WIND_MIN_ANGLE:
		return 0
	else:
		return angle


func get_max_speed(angle: float) -> float:
	if 1.0471975511965 < angle and angle < 1.0471975511967:
		return 0.0
	
	var clampedAngle = clamp_wind_angle(angle)
	if clampedAngle == 0.0:
		return 0.0
	else:
		var wind_weight = inverse_lerp(WIND_MIN_ANGLE, WIND_MAX_ANGLE, angle)
		speed.progress_ratio = wind_weight
		return speed.position.length() / MAGNIFIER


func _ready():
	for point in curve.get_baked_points():
		line.add_point(point)


func _process(_delta):
	if Engine.is_editor_hint():
		# balance positions
		mirror_point(0)
		mirror_point(1)
		mirror_point(2)
		
		get_max_speed(PI/3)


func mirror_point(index: int) -> void:
	curve.set_point_position(6 - index, mirror_x(curve.get_point_position(index)))
	curve.set_point_in(6 - index, mirror_x(curve.get_point_out(index)))
	curve.set_point_out(6 - index, mirror_x(curve.get_point_in(index)))


func mirror_x(v: Vector2) -> Vector2:
	v.x = -v.x
	return v
