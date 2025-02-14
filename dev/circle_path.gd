class_name CirclePath
extends Path2D

@export var size: float = 50:
	set(value):
		size = value
		var half_size = size / 2
		
		# resize the curve
		curve.set_point_position(0, Vector2(0,-size))
		curve.set_point_out(0, Vector2(half_size, 0))
		
		curve.set_point_position(1, Vector2(size, 0))
		curve.set_point_in(1, Vector2(0, -half_size))
		curve.set_point_out(1, Vector2(0, half_size))
		
		curve.set_point_position(2, Vector2(0, size))
		curve.set_point_in(2, Vector2(half_size, 0))
		curve.set_point_out(2, Vector2(-half_size, 0))
		
		curve.set_point_position(3, Vector2(-size, 0))
		curve.set_point_in(3, Vector2(0, half_size))
		curve.set_point_out(3, Vector2(0, -half_size))
		
		curve.set_point_position(4, Vector2(0, -size))
		curve.set_point_in(4, Vector2(-half_size, 0))
		
		# draw the points
		if has_node("Line2D"):
			var line: Line2D = get_node("Line2D")
			line.clear_points()
			
			for point in curve.get_baked_points():
				line.add_point(point)
