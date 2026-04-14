extends Control

@onready var menu := $RootContainer/HBoxContainer/LeftContainer/ForegroundContainer/VBoxContainer/MarginContainer/Menu
@onready var sub_menu := $RootContainer/HBoxContainer/LeftContainer/ForegroundContainer/VBoxContainer/MarginContainer/SubMenu

const SLIDE_AMOUNT := 100.0
const DURATION := 0.4

func _ready() -> void:
	sub_menu.visible = false
	sub_menu.position.x = SLIDE_AMOUNT
	sub_menu.modulate.a = 0.0


func _slide_to(incoming: Control, outgoing: Control, reverse: bool = false) -> void:
	var tween := create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

	outgoing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in outgoing.get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if not reverse:
		incoming.visible = true
		incoming.position.x = SLIDE_AMOUNT
		incoming.scale = Vector2(0.85, 0.85)
		incoming.modulate.a = 0.0

	tween.tween_property(outgoing, "position:x", -SLIDE_AMOUNT if not reverse else SLIDE_AMOUNT, DURATION)
	tween.tween_property(outgoing, "scale", Vector2(0.85, 0.85), DURATION)
	tween.tween_property(outgoing, "modulate:a", 0.125 if not reverse else 0.0, DURATION)

	tween.tween_property(incoming, "position:x", 0.0, DURATION)
	tween.tween_property(incoming, "scale", Vector2(1.0, 1.0), DURATION)
	tween.tween_property(incoming, "modulate:a", 1.0, DURATION)

	tween.chain().tween_callback(func():
		if reverse:
			outgoing.visible = false
			outgoing.position.x = SLIDE_AMOUNT
			outgoing.scale = Vector2(1.0, 1.0)
			outgoing.modulate.a = 0.0

		incoming.mouse_filter = Control.MOUSE_FILTER_STOP
		for child in incoming.get_children():
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_STOP
	)


func _on_resolve_pressed() -> void:
	_slide_to(sub_menu, menu)


func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/eni-school-project/particle-swarm-optimization")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_slide_to(menu, sub_menu, true)


func _on_point_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/general.tscn")
