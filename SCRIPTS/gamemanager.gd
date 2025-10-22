extends Node

var current_area = 1
var area_path = "res://SCENES/Areas/"

func next_level():
	current_area += 1
	var full_path = area_path + "area_" + str(current_area) + ".tscn"

	if ResourceLoader.exists(full_path):
		get_tree().change_scene_to_file(full_path)
		print("The player has moved to area " + str(current_area))
	else:
		print("Area scene not found:", full_path)
