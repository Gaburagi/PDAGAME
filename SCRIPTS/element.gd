extends Area2D

func _ready():
	# optional: ensure this coin is in the correct group for debugging/tracking
	add_to_group("push_coin")

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		# call the autoload by its exact name (case-sensitive)
		Gamemanager.push_coin()
		queue_free()
