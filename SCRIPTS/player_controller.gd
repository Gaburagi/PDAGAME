extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0
@export var drop_time := 0.2  # how long collisions stay off when dropping

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var can_drop = true

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_multiplier

	if event.is_action_pressed("move_down") and is_on_floor() and can_drop:
		drop_through_platform()


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Horizontal movement
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)

	move_and_slide()


func drop_through_platform():
	can_drop = false
	velocity.y = 100  # small downward push so player immediately leaves platform
	set_collision_mask_value(9, false)  # temporarily disable collision with one-way platforms

	await get_tree().create_timer(drop_time).timeout
	set_collision_mask_value(9, true)  # re-enable collision
	can_drop = true
