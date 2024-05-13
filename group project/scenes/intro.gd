extends Node2D


func _on_enter_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_exit_pressed():
	get_tree().quit()
