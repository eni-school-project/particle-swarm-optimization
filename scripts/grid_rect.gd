extends ColorRect

func _ready() -> void:
	_update_size()
	get_viewport().size_changed.connect(_update_size)

func _update_size() -> void:
	var s = get_viewport_rect().size
	
	size = s
	material.set_shader_parameter("node_size", s)
