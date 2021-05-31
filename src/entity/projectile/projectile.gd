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
var _spawn_pos := Vector2() setget private_set 
var _distance_to_travel: float = INF setget private_set # Distance to travel to before "landing".
onready var offset: Vector2 = $Offset.position


func _physics_process(delta: float) -> void:
	var direction: Vector2 = transform.basis_xform(Vector2.RIGHT)
	var new_pos: Vector2 = direction * speed * delta + position
	match flight_mode:
		FlightMode.LANDING:
			if new_pos.distance_squared_to(_spawn_pos - offset) >= _distance_to_travel:
				new_pos = direction * sqrt(_distance_to_travel) + _spawn_pos - offset
				queue_free()
			else:
				continue
	position = new_pos


func set_global_spawn_pos(p_global_pos: Vector2) -> void:
	_spawn_pos = to_local(p_global_pos)


func set_distance_to_travel(p_distance: float) -> void:
	_distance_to_travel = p_distance * p_distance


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func private_set(_value=null):
	print("ERROR: Access to Private Variable.")
	print_stack()
	pass
