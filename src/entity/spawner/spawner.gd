class_name Spawner
extends Node2D

const EnemyScene := preload("res://src/entity/enemy/enemy.tscn")

var target: Node2D

func set_target(new_target: Node2D) -> void:
	target = new_target

func get_path_direction(unit_position: Vector2) -> Vector2:
	return target.transform.get_origin()

func spawn_enemies(enemies: int, initial_position: Vector2) -> void:
	transform.origin = initial_position
	
	look_at(target.transform.get_origin())
	
	for i in enemies:
		var new_enemy: Enemy = EnemyScene.instance()
		
		new_enemy.look_at(target.transform.get_origin())

		add_child(new_enemy)
