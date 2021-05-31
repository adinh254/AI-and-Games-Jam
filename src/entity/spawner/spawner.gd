class_name Spawner
extends Node2D

const EnemyScene := preload("res://src/entity/enemy/enemy.tscn")

var target: Node2D

func set_target(new_target: Node2D) -> void:
	target = new_target

func get_path_direction(unit_global_pos: Vector2) -> Vector2:
	return unit_global_pos.direction_to(target.global_position)

func spawn_enemies(enemies: int, initial_position: Vector2) -> void:
	transform.origin = initial_position
	
	for i in enemies:
		var new_enemy: Enemy = EnemyScene.instance()

		add_child(new_enemy)
