class_name Spawner
extends Node2D

const EnemyScene := preload("res://src/entity/enemy/enemy.tscn")

var target: Node2D
var path: Path2D
var path_follow := PathFollow2D.new()


func set_path(p_path: Path2D) -> void:
	path = p_path
	path.add_child(path_follow)


func set_target(new_target: Node2D) -> void:
	target = new_target


func get_path_direction(p_global_pos: Vector2) -> Vector2:
	var offset: float = path.curve.get_closest_offset(path.to_local(p_global_pos))
	path_follow.offset = offset
	return path_follow.transform.x


func spawn_enemies(enemies: int, initial_position: Vector2) -> void:
	transform.origin = initial_position
	
	for i in enemies:
		var new_enemy: Enemy = EnemyScene.instance()

		add_child(new_enemy)
