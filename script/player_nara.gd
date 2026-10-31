extends CharacterBody2D


# =====================================================
# NODE
# =====================================================

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = get_node_or_null("Camera2D") as Camera2D

@onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX
@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX
@onready var walk_sfx: AudioStreamPlayer2D = $WalkSFX


# =====================================================
# AUDIO
# =====================================================

@export var walk_sounds: Array[AudioStream] = []

var step_timer: float = 0.0

const WALK_STEP_TIME: float = 0.35
const RUN_STEP_TIME: float = 0.20


# =====================================================
# RESPAWN
# =====================================================

var respawn_position: Vector2
var is_respawning: bool = false
var normal_collision_mask: int


# =====================================================
# MOVEMENT
# =====================================================

const WALK_SPEED: float = 450.0
const RUN_SPEED: float = 750.0
const JUMP_VELOCITY: float = -950.0


var gravity = ProjectSettings.get_setting(
	"physics/2d/default_gravity"
)


# =====================================================
# READY
# =====================================================

func _ready():

	# Posisi awal Nara menjadi checkpoint pertama
	respawn_position = global_position


	# Simpan collision mask normal
	normal_collision_mask = collision_mask


	print("==============================")
	print("PLAYER AUDIO SCRIPT AKTIF")
	print("Jump stream: ", jump_sfx.stream)
	print("Hurt stream: ", hurt_sfx.stream)
	print("Jumlah walk sound: ", walk_sounds.size())
	print("==============================")


# =====================================================
# PHYSICS PROCESS
# =====================================================

func _physics_process(delta):

	# =================================================
	# SEDANG JATUH KARENA DURI / HAZARD
	# =================================================

	if is_respawning:

		velocity.y += gravity * delta

		move_and_slide()

		return


	# =================================================
	# GRAVITY
	# =================================================

	if not is_on_floor():

		velocity.y += gravity * delta


	# =================================================
	# JUMP
	# =================================================

	if (
		Input.is_action_just_pressed("jump")
		and is_on_floor()
	):

		print("JUMP SOUND DIPANGGIL")

		velocity.y = JUMP_VELOCITY

		jump_sfx.play()


	# =================================================
	# MOVEMENT
	# =================================================

	var direction = Input.get_axis(
		"move_left",
		"move_right"
	)


	var speed: float = WALK_SPEED


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


	# =================================================
	# FLIP
	# =================================================

	if direction > 0:

		sprite.flip_h = false


	elif direction < 0:

		sprite.flip_h = true


	# =================================================
	# ANIMATION
	# =================================================

	if not is_on_floor():

		sprite.play("jump")


	elif direction != 0:

		if Input.is_action_pressed("run"):

			sprite.play("run")

		else:

			sprite.play("walk")


	else:

		sprite.play("idle")


	# =================================================
	# GERAK
	# =================================================

	move_and_slide()


	# =================================================
	# SUARA LANGKAH
	# =================================================

	update_footsteps(delta)


	# =================================================
	# CHECKPOINT
	# =================================================

	update_respawn_position()


# =====================================================
# FOOTSTEP
# =====================================================

func update_footsteps(delta):

	# Tidak bunyi kalau sedang lompat
	if not is_on_floor():

		step_timer = 0.0

		return


	# Tidak bunyi kalau diam
	if abs(velocity.x) < 10:

		step_timer = 0.0

		return


	step_timer -= delta


	if step_timer <= 0:

		play_footstep()


		if Input.is_action_pressed("run"):

			step_timer = RUN_STEP_TIME


		else:

			step_timer = WALK_STEP_TIME


# =====================================================
# PLAY FOOTSTEP
# =====================================================

func play_footstep():

	if walk_sounds.is_empty():

		print("WALK SOUNDS MASIH KOSONG!")

		return


	var sound: AudioStream = (
		walk_sounds.pick_random()
	)


	walk_sfx.stream = sound


	# Sedikit variasi suara
	walk_sfx.pitch_scale = randf_range(
		0.95,
		1.05
	)


	print("FOOTSTEP SOUND")


	walk_sfx.play()


# =====================================================
# CHECKPOINT / RESPAWN POSITION
# =====================================================

func update_respawn_position():

	# Jangan update checkpoint kalau:
	# - sedang tidak berada di lantai
	# - sedang proses respawn

	if not is_on_floor():
		return


	if is_respawning:
		return


	# Cek collision hasil move_and_slide
	for i in range(
		get_slide_collision_count()
	):

		var collision = (
			get_slide_collision(i)
		)


		if collision == null:
			continue


		# =================================================
		# CEK APAKAH COLLISION ADA DI BAWAH NARA
		# =================================================

		if collision.get_normal().y < -0.7:

			var platform = (
				collision.get_collider()
			)


			if platform == null:
				continue


			# =================================================
			# PLATFORM BERDURI
			# JANGAN JADI CHECKPOINT
			# =================================================

			if platform.is_in_group(
				"danger_platform"
			):

				return


			# =================================================
			# PLATFORM RAPUH
			# JANGAN JADI CHECKPOINT
			# =================================================

			if platform.is_in_group(
				"fragile_platform"
			):

				return


			# =================================================
			# PLATFORM NORMAL
			# SIMPAN CHECKPOINT
			# =================================================

			respawn_position = global_position


# =====================================================
# KENA DURI / HAZARD
# =====================================================

func hit_hazard():

	# Jangan kena damage berkali-kali
	# ketika sedang respawn

	if is_respawning:

		return


	print("HURT SOUND DIPANGGIL")


	is_respawning = true


	# =================================================
	# STOP FOOTSTEP
	# =================================================

	if walk_sfx.playing:

		walk_sfx.stop()


	# =================================================
	# SUARA SAKIT
	# =================================================

	hurt_sfx.play()


	# =================================================
	# KURANGI NYAWA
	# =================================================

	var level = get_tree().current_scene


	if level.has_method("take_damage"):

		level.take_damage(1)


	# =================================================
	# KAMERA
	# =================================================

	if camera != null:

		camera.top_level = true


	# =================================================
	# NARA JATUH
	# =================================================

	collision_mask = 0


	velocity.x = 0
	velocity.y = 700


	# Tunggu supaya animasi jatuh terlihat
	await get_tree().create_timer(
		1.0
	).timeout


	# =================================================
	# RESPAWN KE PLATFORM NORMAL TERAKHIR
	# =================================================

	global_position = respawn_position


	velocity = Vector2.ZERO


	# Aktifkan collision kembali
	collision_mask = normal_collision_mask


	# =================================================
	# KEMBALIKAN KAMERA
	# =================================================

	if camera != null:

		camera.top_level = false

		camera.position = Vector2.ZERO


	# Reset suara langkah
	step_timer = 0.0


	# Respawn selesai
	is_respawning = false
