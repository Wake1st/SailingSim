class_name SailMesh
extends MeshInstance3D

@export_category("Dynamics")
@export var wind_effectiveness: float = 0.01

@export_category("Dimentions")
@export var total_height: float = 3.0
@export var total_width: float = 3.0
@export var vertical_segments: int = 30
@export var horizontal_segments: int = 30

@onready var material: ShaderMaterial = ShaderMaterial.new()
var shader:Shader = preload("res://boat/sail_mesh.gdshader")

var height_per_segment: float = total_height / vertical_segments
var width_per_segment: float = total_width / horizontal_segments

var normals = PackedVector3Array()
var vertices = PackedVector3Array()


func distort_sail(magnitude: float) -> void:
	print("distortion: ", magnitude * wind_effectiveness)
	material.set_shader_parameter("x_amplitude", magnitude * wind_effectiveness)


func _ready():
	build_mesh()
	
	# set the base uniform values
	material.set_shader_parameter("height", total_height)
	material.set_shader_parameter("offset", pow(total_height/2,2))


#region Mesh Generation
func build_mesh() -> void:
	material.shader = shader
	
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
	st.set_material(material)
	
	for v in vertices.size(): 
		st.set_normal(normals[v])
		st.add_vertex(vertices[v])
	
	mesh = st.commit()


func build_triangle(row: float, col: float) -> void:
	var base_row: float = row * height_per_segment
	var base_col: float = col * width_per_segment
	var width: float = (col + 1) * width_per_segment
	var height: float = (row + 1) * height_per_segment
	
	# +X
	vertices.push_back(Vector3(0,base_row,base_col))	# BR
	vertices.push_back(Vector3(0,base_row,width))			# BL
	vertices.push_back(Vector3(0,height,base_col))		# TR
	
	normals.push_back(Vector3.RIGHT)
	normals.push_back(Vector3.RIGHT)
	normals.push_back(Vector3.RIGHT)
	
	# -X
	vertices.push_back(Vector3(0,base_row,base_col))	# BR
	vertices.push_back(Vector3(0,height,base_col))		# TR
	vertices.push_back(Vector3(0,base_row,width))			# BL
	
	normals.push_back(Vector3.LEFT)
	normals.push_back(Vector3.LEFT)
	normals.push_back(Vector3.LEFT)


func build_square(row: float, col: float) -> void:
	var base_row: float = row * height_per_segment
	var base_col: float = col * width_per_segment
	var width: float = (col + 1) * width_per_segment
	var height: float = (row + 1) * height_per_segment
	
	# +X
	vertices.push_back(Vector3(0,base_row,base_col))	# BR
	vertices.push_back(Vector3(0,base_row,width))			# BL
	vertices.push_back(Vector3(0,height,base_col))		# TR
	
	vertices.push_back(Vector3(0,base_row,width))			# BL
	vertices.push_back(Vector3(0,height,width))				# TL
	vertices.push_back(Vector3(0,height,base_col))		# TR
	
	normals.push_back(Vector3.RIGHT)
	normals.push_back(Vector3.RIGHT)
	normals.push_back(Vector3.RIGHT)
	
	normals.push_back(Vector3.RIGHT)
	normals.push_back(Vector3.RIGHT)
	normals.push_back(Vector3.RIGHT)
	
	
	# -X
	vertices.push_back(Vector3(0,base_row,base_col))	# BR
	vertices.push_back(Vector3(0,height,base_col))		# TR
	vertices.push_back(Vector3(0,base_row,width))			# BL
	
	vertices.push_back(Vector3(0,base_row,width))			# BL
	vertices.push_back(Vector3(0,height,base_col))		# TR
	vertices.push_back(Vector3(0,height,width))				# TL
	
	normals.push_back(Vector3.LEFT)
	normals.push_back(Vector3.LEFT)
	normals.push_back(Vector3.LEFT)
	
	normals.push_back(Vector3.LEFT)
	normals.push_back(Vector3.LEFT)
	normals.push_back(Vector3.LEFT)
#endregion
