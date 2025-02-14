class_name MeshGenerator

var normals = PackedVector3Array()
var vertices = PackedVector3Array()

var segment_height: float
var segment_width: float


#region External Methods
func build_sail_mesh(material: ShaderMaterial, mesh_data: MeshData) -> ArrayMesh:
	# set common variables
	segment_height = mesh_data.segment_height()
	segment_width = mesh_data.segment_width()
	
	# loop through each row
	for j in mesh_data.vertical_segments:
		# render a triangle if final row, otherwise a whole row
		if j == mesh_data.vertical_segments - 1:
			build_triangle(j, 0)
		else:
			build_clipped_strip(mesh_data, j)
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(material)
	
	for v in vertices.size(): 
		st.set_normal(normals[v])
		st.add_vertex(vertices[v])
	
	return st.commit()


func build_flag_mesh(material: ShaderMaterial, mesh_data: MeshData) -> ArrayMesh:
	# set common variables
	segment_height = mesh_data.segment_height()
	segment_width = mesh_data.segment_width()
	
	# loop through each column
	build_clipped_strip(mesh_data)
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(material)
	
	for v in vertices.size(): 
		st.set_normal(normals[v])
		st.add_vertex(vertices[v])
	
	return st.commit()
#endregion

#region Face Builders
func build_clipped_strip(mesh_data: MeshData, col: int = 0) -> void:
	# loop through each column
	for i in mesh_data.horizontal_segments - col:
		# render a triangle and end of row, otherwise a square
		if i == mesh_data.horizontal_segments - col - 1:
			build_triangle(col, i)
		else:
			build_square(col, i)


func build_triangle(row: float, col: float) -> void:
	var base_row: float = row * segment_height
	var base_col: float = col * segment_width
	var width: float = (col + 1) * segment_width
	var height: float = (row + 1) * segment_height
	
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
	var base_row: float = row * segment_height
	var base_col: float = col * segment_width
	var width: float = (col + 1) * segment_width
	var height: float = (row + 1) * segment_height
	
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
