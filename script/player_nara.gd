extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const WALK_SPEED = 450.0
const RUN_SPEED = 750.0
const JUMP_VELOCITY = -950.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")

	var speed = WALK_SPEED

	if Input.is_action_pressed("run"):
		speed = RUN_SPEED

	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)

	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	if not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		if Input.is_action_pressed("run"):
			sprite.play("run")
		else:
			sprite.play("walk")
	else:
		sprite.play("idle")

	move_and_slide()
