class_name Projectile
extends Area2D


enum PenetrationMode {
	SOFT,
	LIGHT,
	MEDIUM,
	HEAVY,
}
enum FlightMode {
	PERSISTENT,
	LANDING,
}


signal hit_effect
export(PenetrationMode) var penetration_mode: int = PenetrationMode.SOFT
export(FlightMode) var flight_mode: int = FlightMode.PERSISTENT
export var speed: float = 500.0
var target_global_pos := Vector2.ZERO setget set_target_global_pos
var _target_pos := Vector2.ZERO setget private_set # Target global position converted to local coordinates.
var _flight_dir := Vector2.ZERO setget private_set


func _physics_process(delta: float) -> void:
	var final_pos: Vector2 = _flight_dir * speed * delta + position
	match flight_mode:
		FlightMode.LANDING:
			if final_pos >= _target_pos:
				position = _target_pos
			else:
				continue
		_:
			position = final_pos


func set_target_global_pos(p_global_pos: Vector2) -> void:
	target_global_pos = p_global_pos
	_target_pos = to_local(target_global_pos)
	_flight_dir = position.direction_to(_target_pos)
	rotation = get_angle_to(_target_pos)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func private_set(_value=null):
	print("ERROR: Access to Private Variable.")
	print_stack()
	pass
