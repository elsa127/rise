extends Control


# ==========================================
# SIGNAL
# ==========================================

signal next_level_requested
signal main_menu_requested


# ==========================================
# ASSET BINTANG
# Diisi lewat Inspector
# ==========================================

@export var active_star_texture: Texture2D
@export var inactive_star_texture: Texture2D


# ==========================================
# NODE
# ==========================================

@onready var star1: TextureRect = $Star1
@onready var star2: TextureRect = $Star2
@onready var star3: TextureRect = $Star3

@onready var time_result: Label = $TimeResult
@onready var crystal_result: Label = $CrystalResult
@onready var score_result: Label = $ScoreResult
@onready var height_result: Label = $HeightResult

@onready var next_level_button: TextureButton = $NextLevelButton
@onready var main_menu_button: TextureButton = $MainMenuButton


# ==========================================
# READY
# ==========================================

func _ready():
	# Awal game UI tidak terlihat
	visible = false

	# Tetap aktif walaupun game sedang pause
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Sambungkan tombol
	next_level_button.pressed.connect(_on_next_level_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


# ==========================================
# TAMPILKAN HASIL LEVEL
# ==========================================

func show_result(
	time_text: String,
	crystals_collected: int,
	total_crystals: int,
	score: int,
	height: int
):
	# Waktu
	time_result.text = time_text

	# Crystal
	crystal_result.text = (
		str(crystals_collected)
		+ "/"
		+ str(total_crystals)
	)

	# Score
	score_result.text = str(score)

	# Height
	height_result.text = str(height) + " M"

	# Hitung bintang
	var stars = calculate_stars(
		crystals_collected,
		total_crystals
	)

	update_stars(stars)

	# Tampilkan layar Level Complete
	visible = true


# ==========================================
# HITUNG BINTANG
# ==========================================

func calculate_stars(
	crystals_collected: int,
	total_crystals: int
) -> int:

	# Finish pasti minimal 1 bintang
	var stars = 1

	if total_crystals <= 0:
		return stars

	# Minimal 60% crystal
	# Contoh 3/5
	if crystals_collected >= ceil(total_crystals * 0.6):
		stars = 2

	# Semua crystal
	if crystals_collected >= total_crystals:
		stars = 3

	return stars


# ==========================================
# UPDATE GAMBAR BINTANG
# ==========================================

func update_stars(stars: int):

	if active_star_texture == null:
		print("Active Star Texture belum diisi!")
		return

	if inactive_star_texture == null:
		print("Inactive Star Texture belum diisi!")
		return


	if stars >= 1:
		star1.texture = active_star_texture
	else:
		star1.texture = inactive_star_texture


	if stars >= 2:
		star2.texture = active_star_texture
	else:
		star2.texture = inactive_star_texture


	if stars >= 3:
		star3.texture = active_star_texture
	else:
		star3.texture = inactive_star_texture


# ==========================================
# NEXT LEVEL
# ==========================================

func _on_next_level_pressed():
	get_tree().paused = false

	next_level_requested.emit()


# ==========================================
# MAIN MENU
# ==========================================

func _on_main_menu_pressed():
	get_tree().paused = false

	main_menu_requested.emit()
