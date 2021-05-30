class_name Spawner
extends Node2D


func get_path_direction(unit_position: Vector2) -> Vector2:
	return get_closest_turret(unit_position)

func spawn_enemies(enemies: int, initial_position: Vector2) -> void:
	transform.origin = initial_position

	var point = get_closest_turret(transform.origin)
	
	var angle = atan2(position.x - point.x, position.y - point.y)
	
	for i in enemies:
		var new_enemy: Enemy = Enemy.instance()
		
		new_enemy.rotate(angle)

func get_closest_turret(unit_position: Vector2) -> Vector2:
	# we would like to return the closest turret
	# for now we will return center
	var point = get_viewport_rect().size / 2

	return Vector2(unit_position.x - point.x, unit_position.y - point.y)
