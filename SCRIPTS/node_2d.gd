extends Node
class_name GameManager

var current_area := 1
var area_path := "res://SCENES/Areas/"
var hud : HUD
var coins := 0
var required_coins := 4  # how many to open the portal

func _ready() -> void:
	await get_tree().process_frame
	hud = get_tree().get_first_node_in_group("hud")
	if hud:
		reset_coins()
	else:
		print("HUD not found in scene tree.")


func next_level():
	current_area += 1
	var full_path := area_path + "area_" + str(current_area) + ".tscn"

	if ResourceLoader.exists(full_path):
		get_tree().change_scene_to_file(full_path)
		await get_tree().process_frame
		set_up_area()
		hud = get_tree().get_first_node_in_group("hud")
		print("Moved to area " + str(current_area))
	else:
		print("Area not found:", full_path)


func set_up_area():
	reset_coins()


# Adds a coin (+1)
func add_coin():
	coins += 1
	_update_coin_state()


# Removes a coin (-1)
func remove_coin():
	coins = max(0, coins - 1)  # don’t go below 0
	_update_coin_state()


# Internal: updates HUD + portal state
func _update_coin_state():
	if hud:
		hud.update_coin(coins)

	var portal := get_tree().get_first_node_in_group("area_exits") as AreaExit
	if portal:
		if coins >= required_coins:
			portal.open()
			if hud: hud.portal_opened()
		else:
			portal.close()
			if hud: hud.portal_closed()


func reset_coins():
	coins = 0
	_update_coin_state()
	print("Coins reset.")
