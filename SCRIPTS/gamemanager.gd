extends Node

var current_area := 1
var area_path := "res://SCENES/Areas/"
var hud
var coins_total := 0        # total number of push+pop coins in current area
var coins_collected := 0    # how many have been taken
var pda_stack: Array = []   # push/pop tracking
var portal_unlocked := false

func _ready() -> void:
	await get_tree().process_frame
	hud = get_tree().get_first_node_in_group("hud")
	reset_area()


# 🔁 Reset everything on load or scene change
func reset_area() -> void:
	pda_stack.clear()
	coins_total = get_tree().get_nodes_in_group("push_coin").size() + get_tree().get_nodes_in_group("pop_coin").size()
	coins_collected = 0
	portal_unlocked = false

	var portal := get_tree().get_first_node_in_group("area_exits")
	if portal:
		portal.close()

	if hud:
		hud.update_coin(coins_collected)
	print("🔄 Reset coins and portal closed.")


# 🟢 Called by PushCoin
func push_coin():
	pda_stack.append("coin")
	coins_collected += 1
	_check_portal()
	print("🟢 Push — stack size:%s" % pda_stack.size())


# 🔴 Called by PopCoin
func pop_coin():
	if pda_stack.size() > 0:
		pda_stack.pop_back()
	coins_collected += 1
	_check_portal()
	print("🔴 Pop — stack size:%s" % pda_stack.size())


# 🧩 Main check — opens portal only when all collected AND stack is empty
func _check_portal():
	var remaining := coins_total - coins_collected
	var portal := get_tree().get_first_node_in_group("area_exits")

	print("🧩 Remaining:%s | Stack size:%s | Unlocked:%s" %
		[remaining, pda_stack.size(), portal_unlocked])

	if remaining <= 0 and pda_stack.is_empty() and not portal_unlocked:
		if portal:
			portal.open()
			portal_unlocked = true
	else:
		if portal and not portal_unlocked:
			portal.close()


# 🌍 Next level transition
func next_level():
	current_area += 1
	var full_path := "%sarea_%s.tscn" % [area_path, str(current_area)]
	if ResourceLoader.exists(full_path):
		get_tree().change_scene_to_file(full_path)
		await get_tree().process_frame
		reset_area()
		print("➡️ Next level: Area %s" % str(current_area))
	else:
		print("❌ Area scene not found:", full_path)
