extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = get_node_or_null("Camera2D") as Camera2D

# Posisi respawn terakhir
var respawn_position: Vector2

# Apakah Nara sedang jatuh karena kena hazard
var is_respawning = false

# Menyimpan collision mask asli Player
var normal_collision_mask: int


# ==============================
# MOVEMENT SETTINGS
# ==============================

const WALK_SPEED = 450.0
const RUN_SPEED = 750.0
const JUMP_VELOCITY = -950.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# ==============================
# READY
# ==============================

func _ready():
	# Posisi awal Nara menjadi checkpoint pertama
	respawn_position = global_position

	# Simpan collision mask Player
	normal_collision_mask = collision_mask


# ==============================
# PLAYER MOVEMENT
# ==============================

func _physics_process(delta):

	# ==========================================
	# Kalau sedang kena duri / hazard
	# Nara hanya jatuh dan tidak bisa dikontrol
	# ==========================================

	if is_respawning:
		velocity.y += gravity * delta
		move_and_slide()
		return


	# ==========================================
	# GRAVITY
	# ==========================================

	if not is_on_floor():
		velocity.y += gravity * delta


	# ==========================================
	# JUMP
	# ==========================================

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# ==========================================
	# MOVEMENT KIRI / KANAN
	# ==========================================

	var direction = Input.get_axis("move_left", "move_right")


	# Default jalan
	var speed = WALK_SPEED


	# Kalau Shift ditekan → lari
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED


	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			WALK_SPEED
		)


	# ==========================================
	# BALIK ARAH SPRITE
	# ==========================================

	if direction > 0:
		sprite.flip_h = false

	elif direction < 0:
		sprite.flip_h = true


	# ==========================================
	# ANIMASI
	# ==========================================

	if not is_on_floor():

		sprite.play("jump")

	elif direction != 0:

		if Input.is_action_pressed("run"):
			sprite.play("run")

		else:
			sprite.play("walk")

	else:

		sprite.play("idle")


	# ==========================================
	# GERAKKAN PLAYER
	# ==========================================

	move_and_slide()


	# Cek apakah Nara berdiri di platform aman
	update_respawn_position()


# ==============================
# CHECKPOINT PLATFORM
# ==============================

func update_respawn_position():

	# Jangan update checkpoint kalau sedang lompat
	# atau sedang kena hazard
	if not is_on_floor() or is_respawning:
		return


	for i in range(get_slide_collision_count()):

		var collision = get_slide_collision(i)


		# Normal Y negatif berarti collision berasal
		# dari permukaan di bawah kaki Player
		if collision.get_normal().y < -0.7:

			var platform = collision.get_collider()


			# Jangan jadikan platform berduri checkpoint
			if platform != null:

				if not platform.is_in_group("danger_platform"):

					respawn_position = global_position


# ==============================
# KENA DURI / HAZARD
# ==============================

func hit_hazard():

	# Mencegah damage berkali-kali
	# selama proses jatuh
	if is_respawning:
		return


	is_respawning = true


	# Ambil Level1
	var level = get_tree().current_scene


	# ==========================================
	# KURANGI NYAWA
	# ==========================================

	if level.has_method("take_damage"):
		level.take_damage(1)


	# ==========================================
	# KAMERA BERHENTI MENGIKUTI NARA
	# ==========================================

	if camera != null:
		camera.top_level = true


	# ==========================================
	# MATIKAN COLLISION SEMENTARA
	# supaya Nara jatuh menembus platform
	# ==========================================

	collision_mask = 0


	# Stop gerakan horizontal
	velocity.x = 0


	# Dorong Nara ke bawah
	velocity.y = 700


	# Tunggu supaya efek jatuh terlihat
	await get_tree().create_timer(1.0).timeout


	# ==========================================
	# RESPAWN
	# ==========================================

	global_position = respawn_position

	velocity = Vector2.ZERO


	# Hidupkan collision lagi
	collision_mask = normal_collision_mask


	# ==========================================
	# KAMERA KEMBALI KE NARA
	# ==========================================

	if camera != null:
		camera.top_level = false
		camera.position = Vector2.ZERO


	is_respawning = false
