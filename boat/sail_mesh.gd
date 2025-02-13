class_name SailMesh
extends MeshInstance3D

@export var total_height: float = 3.0
@export var total_width: float = 3.0
@export var vertical_segments: int = 6
@export var horizontal_segments: int = 6

var height_per_segment: float = total_height / vertical_segments
var width_per_segment: float = total_width / horizontal_segments

var vertices = PackedVector3Array()


func _ready():
	var mat = StandardMaterial3D.new()
	var color = Color(0.0, 0.7, 0.8)
	mat.albedo_color = color
	
	# loop through each row
	for j in vertical_segments:
			# render a triangle if final row, otherwise a whole row
		if j == vertical_segments - 1:
				build_triangle(j, 0)
		else:
			# loop through each column
			for i in horizontal_segments - j:
				# render a triangle and end of row, otherwise a square
				if i == horizontal_segments - j - 1:
					build_triangle(j, i)
				else:
					build_square(j, i)
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(mat)
	
	for v in vertices.size(): 
		print("color: %s\tvertex: %s" % [color, vertices[v]])
		st.set_normal(Vector3.RIGHT)
		st.set_color(color)
		st.add_vertex(vertices[v])
	
	#st.generate_normals()
	#st.generate_tangents()
	mesh = st.commit()



func build_triangle(row: float, col: float) -> void:
	var base_row: float = row * height_per_segment
	var base_col: float = col * width_per_segment
	var width: float = (col + 1) * width_per_segment
	var height: float = (row + 1) * height_per_segment
	
	vertices.push_back(Vector3(0,base_row,base_col))	# BR
	vertices.push_back(Vector3(0,base_row,width))			# BL
	vertices.push_back(Vector3(0,height,base_col))		# TR


func build_square(row: float, col: float) -> void:
	var base_row: float = row * height_per_segment
	var base_col: float = col * width_per_segment
	var width: float = (col + 1) * width_per_segment
	var height: float = (row + 1) * height_per_segment
	
	vertices.push_back(Vector3(0,base_row,base_col))	# BR
	vertices.push_back(Vector3(0,base_row,width))			# BL
	vertices.push_back(Vector3(0,height,base_col))		# TR
	
	vertices.push_back(Vector3(0,base_row,width))			# BL
	vertices.push_back(Vector3(0,height,width))				# TL
	vertices.push_back(Vector3(0,height,base_col))		# TR
