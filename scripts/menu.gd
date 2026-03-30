extends Node2D

@export var particle_number: int = 20
@export var particle_scene: PackedScene
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	generate_particles()


func generate_particles() -> void:
	for i in particle_number:
		var particle: CharacterBody2D = particle_scene.instantiate()
		particle.position = Vector2(
			randf_range(0.0, screen_size.x),
			randf_range(0.0, screen_size.y)
		)
		
		var speed: float = randf_range(30.0, 20.0)
		var angle: float = randf() * TAU
		particle.velocity = Vector2.from_angle(angle) * speed
		
		$Particles.add_child(particle)
		particle.add_to_group("particles")
