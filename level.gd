class_name Level
extends Node3D

@onready var boat: Boat = $Boat
@onready var wind: Wind = $Wind


func _physics_process(_delta):
	boat.calculate_wind_projection(wind.get_wind())
