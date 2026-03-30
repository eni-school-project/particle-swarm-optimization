extends Node2D


func _ready() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/menu.tscn")
