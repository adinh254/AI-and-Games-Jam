class_name Turret
extends Node2D


signal angle_changed

export var rotation_speed: float = 100.0
export var look_at_mouse: bool = false setget set_look_at_mouse
var _delta_angle: float = 0.0 setget private_set
onready var hard_point: Position2D = $Hardpoint
onready var gun: Gun = hard_point.get_node("Gun")


func _ready() -> void:
	# Convert properties to usable units.
	rotation_speed = deg2rad(rotation_speed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_fire"):
		gun.fire()


func _process(_delta: float) -> void:
	# Gets the current cursor position in the idle/render frame 
	# and sets it as the target angle for the turret to move towards. 
	_delta_angle = get_angle_to(get_global_mouse_position())


func _physics_process(delta: float) -> void:
	_rotate_turret(delta * rotation_speed)
	emit_signal("angle_changed", rotation)


func set_look_at_mouse(p_process_state: bool) -> void:
	# Sets _process state for whether the turret auto rotates towards the cursor.
	set_process(p_process_state)
	set_physics_process(p_process_state)
	set_process_unhandled_input(p_process_state)


func _rotate_turret(p_rotation_speed: float) -> void: 
	# Rotates attached hardpoint towards the at the passed in speed.
	if abs(_delta_angle) < p_rotation_speed: # Delta angle is less than rotation speed.
		global_rotation += _delta_angle
	elif _delta_angle < 0: # Rotate Up
		global_rotation -= p_rotation_speed
	else:
		global_rotation += p_rotation_speed


func private_set(_value=null):
	print("ERROR: Access to Private Variable.")
	print_stack()
	pass
