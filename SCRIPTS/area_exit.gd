extends Area2D

@export var sprite: Sprite2D
var is_open := false

func _ready():
	close()

func open():
	is_open = true
	if sprite and sprite.region_enabled:
		sprite.region_rect.position.x = 64  # adjust offset depending on your texture
	print("🚪 Portal opened visually!")

func close():
	is_open = false
	if sprite and sprite.region_enabled:
		sprite.region_rect.position.x = 0
	print("🚪 Portal closed!")

func _on_body_entered(body: Node2D) -> void:
	if is_open and body is PlayerController:
		Gamemanager.next_level()
