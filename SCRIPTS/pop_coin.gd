extends Area2D

func _ready():
	# optional: group for tracking
	add_to_group("pop_coin")

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		Gamemanager.pop_coin()
		queue_free()
