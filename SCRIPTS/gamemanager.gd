extends Node
class_name GameManager

var current_area := 1
var area_path := "res://SCENES/Areas/"

var coins := 0

func _ready() -> void:
	reset_coins()


func next_level():
	current_area += 1
	var full_path := area_path + "area_" + str(current_area) + ".tscn"

	if ResourceLoader.exists(full_path):
		get_tree().change_scene_to_file(full_path)
		await get_tree().process_frame  # wait a frame to ensure the scene is loaded
		set_up_area()
		print("The player has moved to area " + str(current_area))
	else:
		print("Area scene not found:", full_path)

func set_up_area():
	reset_coins()

func add_coin():
	coins += 1
	if coins >= 4:
		var portal := get_tree().get_first_node_in_group("area_exits") as AreaExit
		if portal:
			portal.open()

func reset_coins():
	coins = 0
	print("Coins have been reset.")
