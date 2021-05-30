class_name Gun
extends Node2D

signal fire

const projectile_type := preload("res://src/entity/projectile/projectile.tscn")

onready var muzzle: Position2D = $Muzzle
onready var pointer: Sprite = $Pointer
export var pointer_disabled: bool = true setget set_pointer_disabled
export var pointer_speed: float = 500.0
export var max_range: float = 2000.0
export(Color) var pointer_collision_color = Color.white
#export(Color) var pointer_max_distance_color = Color(1.0, 1.0, 1.0, 0.3)
export(Color) var pointer_min_distance_color = Color(1.0, 1.0, 1.0, 0.3)
var _pointer_x_pos := Vector2.ONE setget private_set
onready var _max_x_threshold: float = max_range - pointer_speed setget private_set
onready var _min_x_threshold: float = muzzle.position.x + pointer_speed setget private_set


func _ready() -> void:
	set_pointer_disabled(pointer_disabled)


func _process(_delta: float) -> void:
	set_process(!pointer_disabled)
	pointer.visible = !pointer_disabled
	_pointer_x_pos = to_local(get_global_mouse_position())


func _physics_process(delta: float) -> void:
	set_physics_process(!pointer_disabled)
	var delta_speed: float = sign(_pointer_x_pos.x) * pointer_speed * delta
	var final_x_pos: float = pointer.position.x + delta_speed
	if _pointer_x_dir == -1 && final_x_pos < _min_x_threshold:
		pointer.position.x = muzzle.position.x
	elif _pointer_x_dir == 1 && final_x_pos > _max_x_threshold:
		pointer.position.x = max_range
	else:
		pointer.position.x = final_x_pos


func set_pointer_disabled(p_disabled: bool) -> void:
	pointer_disabled = p_disabled


func fire() -> void:
	emit_signal("fire", projectile_type, muzzle.global_transform)


func private_set(_value=null):
	print("ERROR: Access to Private Variable.")
	print_stack()
	pass
