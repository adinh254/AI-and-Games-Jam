class_name Gun
extends Node2D

signal fire

const Plasma := preload("res://src/entity/projectile/plasma/plasma.tscn")
const SentryBox := preload("res://src/entity/projectile/sentry_box/sentry_box.tscn")

export var projectile_type: PackedScene = Plasma
export var pointer_disabled: bool = true setget set_pointer_disabled
export var pointer_speed: float = 500.0
export var max_range: float = 2000.0
export(Color) var pointer_collision_color = Color.white
#export(Color) var pointer_max_distance_color = Color(1.0, 1.0, 1.0, 0.3)
export(Color) var pointer_min_distance_color = Color(1.0, 1.0, 1.0, 0.3)
var _target_x_pos: float setget private_set
onready var muzzle: Position2D = $Muzzle
onready var pointer: Sprite = $Pointer


func _ready() -> void:
	set_pointer_disabled(pointer_disabled)


func _process(_delta: float) -> void:
	set_process(!pointer_disabled)
	pointer.visible = !pointer_disabled
	_target_x_pos = to_local(get_global_mouse_position()).x


func _physics_process(delta: float) -> void:
	set_physics_process(!pointer_disabled)
	var ba: float = _target_x_pos - pointer.position.x
	var delta_speed: float = sign(ba) * pointer_speed * delta
	# a = pointer.position.x; b = _target_x_pos; c = pointer.position.x + delta_speed
	var c: float = pointer.position.x + delta_speed
	var bc: float = c - _target_x_pos
	var final_x_pos: float = c
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
	emit_signal("fire", projectile_type, muzzle.global_transform, pointer.global_position)


#func _on_DynamicCamera_zoom_in(p_zoom: Vector2) -> void:
#	pointer.global_scale = p_zoom
#
#
#func _on_DynamicCamera_zoom_out(p_zoom: Vector2) -> void:
#	pointer.global_scale = p_zoom


func private_set(_value=null):
	print("ERROR: Access to Private Variable.")
	print_stack()
	pass
