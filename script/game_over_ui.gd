extends Control


# =====================================================
# SIGNAL
# Tetap ada supaya level_1.gd lama tidak error
# =====================================================

signal retry_requested
signal main_menu_requested


# =====================================================
# SCENE
# =====================================================

@export var main_menu_scene: PackedScene


# =====================================================
# NODE
# =====================================================

@onready var time_result: Label = $TimeResult
@onready var crystal_result: Label = $CrystalResult
@onready var score_result: Label = $ScoreResult
@onready var height_result: Label = $HeightResult

@onready var retry_button: TextureButton = $RetryButton
@onready var main_menu_button: TextureButton = $MainMenuButton


# =====================================================
# READY
# =====================================================

func _ready():

	visible = false

	# Supaya tombol tetap hidup saat game pause
	process_mode = Node.PROCESS_MODE_ALWAYS

	retry_button.disabled = false
	main_menu_button.disabled = false

	retry_button.pressed.connect(
		_on_retry_pressed
	)

	main_menu_button.pressed.connect(
		_on_main_menu_pressed
	)


# =====================================================
# SHOW GAME OVER
# =====================================================

func show_game_over(
	time_text: String,
	crystals_collected: int,
	total_crystals: int,
	score: int,
	height: int
):

	time_result.text = time_text

	crystal_result.text = (
		str(crystals_collected)
		+ "/"
		+ str(total_crystals)
	)

	score_result.text = str(score)

	height_result.text = (
		str(height)
		+ " M"
	)


	visible = true


# =====================================================
# RETRY
# =====================================================

func _on_retry_pressed():

	print("RETRY BUTTON DIPENCET")

	get_tree().paused = false

	get_tree().reload_current_scene()


# =====================================================
# MAIN MENU
# =====================================================

func _on_main_menu_pressed():

	print("MAIN MENU GAME OVER DIPENCET")

	get_tree().paused = false


	if main_menu_scene == null:

		print("ERROR: MAIN MENU SCENE BELUM DIISI!")

		return


	get_tree().change_scene_to_packed(
		main_menu_scene
	)
