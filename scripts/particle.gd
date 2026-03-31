class_name Particle
extends CharacterBody2D

@export var max_speed: float = 20.0
@export var wander_strength: float = 15.0
@export var change_direction_every: float = 0.1

var wander_timer: float = 0.0

var objective: Vector2 = Vector2.ZERO
var best_distance: float = INF

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	max_speed = 200.0 if get_tree().has_group("target") else 20.0
	
	if velocity.length() > max_speed:
		velocity = velocity.limit_length(max_speed)
	
	if (not get_tree().has_group("target")):
		wander_timer -= delta
		if wander_timer <= 0.0:
			var random_nudge = Vector2.from_angle(randf() * TAU) * wander_strength
			velocity += random_nudge
			wander_timer = change_direction_every
		
		var viewport = get_viewport_rect()
		if position.x < 0:
			position.x = viewport.size.x
		elif position.x > viewport.size.x:
			position.x = 0
			
		if position.y < 0:
			position.y = viewport.size.y
		elif position.y > viewport.size.y:
			position.y = 0
