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
var _target_x_pos: float setget private_set


func _ready() -> void:
	set_pointer_disabled(pointer_disabled)


func _process(_delta: float) -> void:
	set_process(!pointer_disabled)
	pointer.visible = !pointer_disabled
	_target_x_pos = to_local(get_global_mouse_position()).x


func _physics_process(delta: float) -> void:
	set_physics_process(!pointer_disabled)
	var delta_speed: float = sign(_target_x_pos) * pointer_speed * delta
	# a = pointer.positioin.x; b = _target_x_pos; c = pointer.position.x + delta_speed
	var c: float = pointer.position.x + delta_speed
	var bc: float = _target_x_pos - c
	var ba: float = _target_x_pos - pointer.position.x
	var final_x_pos: float = c
	if ba * bc < 0: # If the c goes past the target.
		if abs(bc) < abs(delta_speed):
			final_x_pos = _target_x_pos
	if final_x_pos < muzzle.position.x:
		final_x_pos = muzzle.position.x
	elif final_x_pos > max_range:
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
