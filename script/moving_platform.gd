extends AnimatableBody2D


# =====================================================
# SETTING
# =====================================================

# Jarak gerak kanan-kiri dari titik awal
@export var move_distance: float = 300.0

# Kecepatan gerak
@export var move_speed: float = 2.0


# =====================================================
# VARIABLE
# =====================================================

var start_position: Vector2
var time: float = 0.0


# =====================================================
# READY
# =====================================================

func _ready():

	start_position = global_position

	time = 0.0

	print("MOVING PLATFORM AKTIF!")
	print("POSISI AWAL: ", start_position)

	# Pastikan physics process aktif
	set_physics_process(true)


# =====================================================
# GERAK TERUS
# =====================================================

func _physics_process(delta: float):

	time += delta * move_speed


	# Gerak kanan-kiri terus menerus
	global_position.x = (
		start_position.x
		+ sin(time) * move_distance
	)
