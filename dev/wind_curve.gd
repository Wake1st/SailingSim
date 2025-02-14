@tool
class_name WindCurve
extends Path2D

const MIN_ANGLE: float = PI/6
const MAX_ANGLE: float = PI*2
const MAGNIFIER: float = 100

@onready var line = $Line2D
@onready var speed = $Speed


func get_max_speed(angle: float) -> float:
	if angle <= MIN_ANGLE or angle >= MAX_ANGLE:
		return 0
	else:
		var intersection: Vector2
		for i in curve.point_count - 1:
			intersection = Geometry2D.line_intersects_line(
				curve.get_point_position(i),
				curve.get_point_position(i+1),
				Vector2.ZERO,
				Vector2.UP.rotated(angle)
			)
			
			if intersection != null:
				break
		
		speed.position = intersection
		return intersection.length() / MAGNIFIER
		
		#var weight = inverse_lerp(MIN_ANGLE, MAX_ANGLE, angle)
		#speed.progress_ratio = weight
		#return speed.position.length() / MAGNIFIER


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
