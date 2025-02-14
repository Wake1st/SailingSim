class_name FlagMesh
extends MeshInstance3D

@export_category("Dynamics")
@export var wind_effectiveness: float = 1.2
@export var wind_amplitude: float = 0.02

@export_category("Mesh Data")
@export var mesh_data: MeshData

@onready var material: ShaderMaterial = ShaderMaterial.new()
var shader:Shader = preload("res://boat/flag_shader.gdshader")

var mesh_generator = MeshGenerator.new()


func distort_flag(wind: Vector3) -> void:
	# flap flag
	var magnitude: float = wind.length()
	material.set_shader_parameter("frequency", magnitude * wind_effectiveness)
	material.set_shader_parameter("amplitude", magnitude * wind_amplitude)
	
	# rotate flag to wind
	look_at(wind)


func _ready():
	material.shader = shader
	mesh = mesh_generator.build_flag_mesh(material, mesh_data)
