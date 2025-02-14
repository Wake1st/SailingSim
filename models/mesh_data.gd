class_name MeshData
extends Resource

@export_range(0,10) var total_height: float = 1.0
@export_range(0,10) var total_width: float = 1.0
@export_range(0,100) var vertical_segments: int = 5
@export_range(0,100) var horizontal_segments: int = 5


func segment_height() -> float:
	return total_height / vertical_segments


func segment_width() -> float:
	return total_width / horizontal_segments
