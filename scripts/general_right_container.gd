extends MarginContainer

@export var particle_number: int = 8
@export var particle_scene: PackedScene
@export var target_scene: PackedScene

@export var exploration: float = 1.0
@export var exploitation: float = 1.0
#@export var min_inertia: float = 0.4
#@export var max_inertia: float = 0.9
@export var inertia: float = 0.4

var screen_size: Vector2

var global_objective: Vector2 = Vector2.ZERO
var global_best_distance: float = INF

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size


func _physics_process(delta: float) -> void:
	# uncomment below for the target to follow mouse once created
	#if get_tree().has_group("target"):
		#var target: Area2D = get_tree().get_first_node_in_group("target") as Area2D
		#var mouse_pos = get_global_mouse_position()
		#if target.global_position != mouse_pos:
			#target.global_position = mouse_pos
			#reset_pso()
	
	if get_tree().has_group("target"):
		var source: Array[Node] = get_tree().get_nodes_in_group("particles")
		var particles: Array[Particle]
		
		for node in source:
			if node is Particle:
				particles.push_back(node as Particle)
		
		pso(particles, delta)
	
	else:
		reset_pso()


func generate_particles() -> void:
	for i in particle_number:
		var particle: Particle = particle_scene.instantiate()
		particle.position = Vector2(
			randf_range(0.0, screen_size.x),
			randf_range(0.0, screen_size.y)
		)
		
		var speed: float = randf_range(10.0, 20.0)
		var angle: float = randf() * TAU
		particle.velocity = Vector2.from_angle(angle) * speed
		
		$Particles.add_child(particle)
		particle.add_to_group("particles")


func _set_particles_target(value: bool) -> void:
	for node in get_tree().get_nodes_in_group("particles"):
		if node is Particle:
			(node as Particle).set_target(value)


func pso(particles: Array[Particle], _delta: float) -> void:
	var target: Area2D = get_tree().get_first_node_in_group("target") as Area2D
	var target_position: Vector2 = target.global_position
	
	for particle in particles:
		var distance: float = particle.global_position.distance_to(target_position)
		if (distance < particle.best_distance):
			particle.best_distance = distance
			particle.objective = particle.global_position
	
	for particle in particles:
		if (particle.best_distance < global_best_distance):
			global_best_distance = particle.best_distance
			global_objective = particle.objective
	
	for particle in particles:
		particle.velocity = inertia * particle.velocity \
			+ exploration * randf() * (particle.objective - particle.global_position) \
			+ exploitation * randf() * (global_objective - particle.global_position)


func reset_pso() -> void:
	global_best_distance = INF
	global_objective = Vector2.ZERO
	
	var source: Array[Node] = get_tree().get_nodes_in_group("particles")
	for node in source:
		if node is Particle:
			var particle := node as Particle
			particle.best_distance = INF
			particle.objective = particle.global_position


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if get_tree().has_group("particles"):
		if event is InputEventMouseButton:
			
			if (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed:
				if get_tree().has_group("target"):
					var target: Area2D = get_tree().get_first_node_in_group("target") as Area2D
					target.global_position = get_global_mouse_position()

					reset_pso()

				else:
					var target: Area2D = target_scene.instantiate()
					target.add_to_group("target")
					add_child(target)

					target.global_position = get_global_mouse_position()
					move_child(target, $Particles.get_index())

					_set_particles_target(true)

			elif (event.button_index == MOUSE_BUTTON_RIGHT) and event.pressed:
				if get_tree().has_group("target"):
					var target: Area2D = get_tree().get_first_node_in_group("target") as Area2D
					target.queue_free()
					_set_particles_target(false)


func _on_particle_value_changed(value: float) -> void:
	particle_number = int(value)


func _on_inertia_value_changed(value: float) -> void:
	inertia = value


func _on_exploration_value_changed(value: float) -> void:
	exploration = value


func _on_exploitation_value_changed(value: float) -> void:
	exploitation = value


func _on_confirm_pressed() -> void:
	if get_tree().has_group("particles"):
		for node in get_tree().get_nodes_in_group("particles"):
			node.queue_free()
		
		generate_particles()
	else:
		generate_particles()
	
	if get_tree().has_group("target"):
		var target: Area2D = get_tree().get_first_node_in_group("target") as Area2D
		target.queue_free()
		_set_particles_target(false)
