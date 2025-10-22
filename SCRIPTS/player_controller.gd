extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0
@export var drop_time := 0.2

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var can_drop = true

@onready var cam: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null

func _ready():
	if cam:
		cam.set("smoothing/enable", true)
		cam.set("smoothing/speed", 6.0)
		cam.set("smoothing/limit_smoothed", true)

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_multiplier

	if event.is_action_pressed("move_down") and is_on_floor() and can_drop:
		drop_through_platform()

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movement
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)

	move_and_slide()

	# Safe animation handling
	if animation_player:
		if velocity.y < 0.0:
			animation_player.play("jump")
		elif velocity.y > 0.0:
			animation_player.play("fall")
		elif abs(velocity.x) > 0.0:
			animation_player.play("run")
		else:
			animation_player.play("idle")

func drop_through_platform():
	can_drop = false
	velocity.y = 100
	set_collision_mask_value(9, false)
	await get_tree().create_timer(drop_time).timeout
	set_collision_mask_value(9, true)
	can_drop = true
