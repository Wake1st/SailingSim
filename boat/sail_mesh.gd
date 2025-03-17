class_name SailMesh
extends MeshInstance3D

@export_category("Dynamics")
@export var wind_effectiveness: float = 0.01

@export_category("Mesh Data")
@export var mesh_data: MeshData

@onready var material: ShaderMaterial = ShaderMaterial.new()
var shader:Shader = preload("res://boat/sail_mesh.gdshader")

var mesh_generator = MeshGenerator.new()


func distort_sail(wind: Vector3) -> void:
	var dir = 1 if wind.dot(global_basis.x) >= 0.0 else -1
	material.set_shader_parameter("x_amplitude", dir * wind.length() * wind_effectiveness)


func _ready():
	material.shader = shader
	mesh = mesh_generator.build_sail_mesh(material, mesh_data)
	
	# set the base uniform values
	material.set_shader_parameter("height", mesh_data.total_height)
	material.set_shader_parameter("offset", pow(mesh_data.total_height/2,2))
