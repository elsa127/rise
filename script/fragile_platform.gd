extends StaticBody2D


# =====================================================
# NODE
# =====================================================

@onready var sprite: Sprite2D = $Sprite2D
@onready var main_collision: CollisionShape2D = $CollisionShape2D

@onready var detect_area: Area2D = $DetectArea
@onready var detect_collision: CollisionShape2D = $DetectArea/CollisionShape2D

@onready var break_timer: Timer = $BreakTimer


# =====================================================
# SETTING PLATFORM RAPUH
# =====================================================

# Berapa lama platform masih bertahan setelah diinjak
@export var break_delay: float = 5.0

# Kekuatan goyang
@export var shake_strength: float = 2.0

# Lama fade out
@export var fade_duration: float = 1.0


# =====================================================
# STATUS
# =====================================================

var activated: bool = false
var disappearing: bool = false

var original_position: Vector2


# =====================================================
# READY
# =====================================================

func _ready():

	original_position = position


	# Supaya tidak dianggap checkpoint oleh PlayerNara
	add_to_group("fragile_platform")


	# Setting timer otomatis
	break_timer.wait_time = break_delay
	break_timer.one_shot = true
	break_timer.autostart = false


	# Signal DetectArea
	detect_area.body_entered.connect(
		_on_detect_area_body_entered
	)


	# Signal Timer
	break_timer.timeout.connect(
		_on_break_timer_timeout
	)


# =====================================================
# PROCESS
# =====================================================

func _process(_delta):

	# =================================================
	# GOYANG SELAMA MENUNGGU 7 DETIK
	# =================================================

	if activated and not disappearing:

		var shake := sin(
			Time.get_ticks_msec() * 0.025
		)

		position.x = (
			original_position.x
			+ shake * shake_strength
		)


# =====================================================
# NARA MENGINJAK PLATFORM
# =====================================================

func _on_detect_area_body_entered(body):

	# Platform cuma boleh aktif sekali
	if activated:
		return


	# Pastikan yang menginjak Nara
	if body is CharacterBody2D:

		activated = true


		print(
			"PLATFORM RAPUH TERINJAK!"
		)

		print(
			"PLATFORM AKAN HILANG DALAM ",
			break_delay,
			" DETIK"
		)


		# Mulai hitung 7 detik
		break_timer.start()


# =====================================================
# 7 DETIK SELESAI
# =====================================================

func _on_break_timer_timeout():

	if disappearing:
		return


	disappearing = true


	print(
		"PLATFORM RAPUH MULAI MENGHILANG!"
	)


	# Kembalikan posisi ke posisi awal
	# Jadi tidak berhenti dalam posisi miring/goyang
	position = original_position


	# =================================================
	# MATIKAN COLLISION
	# =================================================

	main_collision.set_deferred(
		"disabled",
		true
	)


	detect_collision.set_deferred(
		"disabled",
		true
	)


	# =================================================
	# FADE OUT
	# =================================================

	var tween := create_tween()


	var target_color := modulate

	target_color.a = 0.0


	tween.tween_property(
		self,
		"modulate",
		target_color,
		fade_duration
	)


	# Tunggu fade selesai
	await tween.finished


	# Hapus platform
	queue_free()
