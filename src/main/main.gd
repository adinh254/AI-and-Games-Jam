extends Node2D

const SpawnerScene := preload("res://src/entity/spawner/spawner.tscn")


onready var home: Building = $HomeBase


func _ready():
	# This should be on a timer maybe?
	createSpawner()
	
	pass

func _on_Gun_fire(Projectile, p_global_transform: Transform2D) -> void:
	# https://docs.godotengine.org/en/stable/tutorials/misc/instancing_with_signals.html?highlight=bullet#shooting-example
	var new_projectile: Projectile = Projectile.instance()
	add_child(new_projectile)
	var projectile_rotation: float = p_global_transform.get_rotation()
	new_projectile.global_transform = p_global_transform
	new_projectile.set_direction(Vector2(cos(projectile_rotation), sin(projectile_rotation)))

func createSpawner():
	var new_spawner: Spawner = SpawnerScene.instance()
	
	add_child(new_spawner)

	var screen_size = get_viewport_rect().size
	var random_generator = RandomNumberGenerator.new()
	var random_generator_x = random_generator.randi_range(64, screen_size.x - 64)
	var random_generator_y = random_generator.randi_range(64, screen_size.y - 64)
	
	new_spawner.set_position(Vector2(10, 10))

	#new_spanwer.spawn_enemies(
	#	random_generator.randi_range(5, 10),
	#	Vector2(random_generator_x, random_generator_y)
	#)
