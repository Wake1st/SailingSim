class_name BezierUnitGraph
extends Node2D

const MIN_ANGLE: float = PI/3
const MAX_ANGLE: float = PI*5/3

@onready var speed_circle_1 = $SpeedCircle1
@onready var speed_circle_2 = $SpeedCircle2
@onready var speed_circle_3 = $SpeedCircle3

@onready var wind_curve = $WindCurve
var increasing: bool = true
var angle: float


func _ready():
	speed_circle_1.size = 50
	speed_circle_2.size = 100
	speed_circle_3.size = 150


func _process(delta: float) -> void:
	track_wind(delta)


func track_wind(delta: float) -> void:
	if increasing:
		angle += delta
		if angle >= PI*2:
			increasing = false
	else:
		angle -= delta
		if angle <= 0:
			increasing = true 
	
	var speed = wind_curve.get_max_speed(angle)
