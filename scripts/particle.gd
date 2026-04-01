class_name Particle
extends CharacterBody2D

@export var max_speed: float = 20.0
@export var wander_strength: float = 15.0
@export var change_direction_every: float = 0.1
@export var deceleration: float = 0.92

var wander_timer: float = 0.0

var has_target: bool = false
var is_decelerating: bool = false

var objective: Vector2 = Vector2.ZERO
var best_distance: float = INF

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if is_decelerating:
		velocity *= pow(deceleration, delta * 60.0)
		if (velocity.length() <= 20.0):
			is_decelerating = false
			max_speed = 20.0
	
	else:
		if (velocity.length() > max_speed):
			velocity = velocity.limit_length(max_speed)
		
		if not has_target:
			wander_timer -= delta
			if (wander_timer <= 0.0):
				var random_nudge = Vector2.from_angle(randf() * TAU) * wander_strength
				velocity += random_nudge
				wander_timer = change_direction_every
			
			var viewport = get_viewport_rect()
			if (position.x < 0): position.x = viewport.size.x
			elif (position.x > viewport.size.x): position.x = 0
			if (position.y < 0): position.y = viewport.size.y
			elif (position.y > viewport.size.y): position.y = 0


func set_target(value: bool) -> void:
	has_target = value
	if value:
		is_decelerating = false
		max_speed = 200.0
	else:
		is_decelerating = true
