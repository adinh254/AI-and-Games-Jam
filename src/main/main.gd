extends Node2D


onready var home: Building = $HomeBase

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Gun_fire(Projectile, p_global_transform: Transform2D) -> void:
	# https://docs.godotengine.org/en/stable/tutorials/misc/instancing_with_signals.html?highlight=bullet#shooting-example
	var new_projectile: Projectile = Projectile.instance()
	add_child(new_projectile)
	var projectile_rotation: float = p_global_transform.get_rotation()
	new_projectile.global_transform = p_global_transform
	new_projectile.set_direction(Vector2(cos(projectile_rotation), sin(projectile_rotation)))
