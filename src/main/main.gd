extends Node2D

const SpawnerScene := preload("res://src/entity/spawner/spawner.tscn")


const Plasma := preload("res://src/entity/projectile/plasma/plasma.tscn")
const SentryBox := preload("res://src/entity/projectile/sentry_box/sentry_box.tscn")


onready var home: Building = $HomeBase
onready var base_gun: Gun = home.get_node("Turret/Hardpoint/Gun")
onready var path: Path2D = $Path2D


func _ready():
	# This should be on a timer maybe?
	createSpawner()
#	createSpawner()
#	createSpawner()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ammo_1"):
		base_gun.loaded_ammo_type = Plasma
		print("Plasma Selected.")
	elif event.is_action_pressed("ammo_2"):
		base_gun.loaded_ammo_type = SentryBox
		print("Sentry Selected.")


func createSpawner():
	var new_spawner: Spawner = SpawnerScene.instance()
	add_child(new_spawner)
	new_spawner.set_path(path)
	new_spawner.set_target(home)


	var screen_size = get_viewport_rect().size
	var random_generator = RandomNumberGenerator.new()

	random_generator.randomize()

	var random_generator_x = random_generator.randi_range(64, screen_size.x - 64)
	var random_generator_y = random_generator.randi_range(64, screen_size.y - 64)

	new_spawner.spawn_enemies(
		random_generator.randi_range(2, 2),
		Vector2(random_generator_x, random_generator_y)
	)


func _on_Gun_fire(Projectile, p_global_transform: Transform2D, p_target_global_pos: Vector2) -> void:
	# https://docs.godotengine.org/en/stable/tutorials/misc/instancing_with_signals.html?highlight=bullet#shooting-example
	var new_projectile: Projectile = Projectile.instance()
	new_projectile.connect("hit_effect", self, "_on_Projectile_hit_effect")
	var spawn_global_pos: Vector2 = p_global_transform.get_origin()
	add_child(new_projectile)
	new_projectile.set_global_spawn_pos(spawn_global_pos)
	new_projectile.set_distance_to_travel(spawn_global_pos.distance_to(p_target_global_pos))
	new_projectile.global_rotation = p_global_transform.get_rotation()
	new_projectile.global_position = spawn_global_pos
#	new_projectile.set_target_global_pos(p_target_global_pos)


func _on_Projectile_hit_effect(p_effect: PackedScene, p_global_pos: Vector2) -> void:
	var new_scene: Node2D = p_effect.instance()
	add_child(new_scene)
	new_scene.global_position = p_global_pos
