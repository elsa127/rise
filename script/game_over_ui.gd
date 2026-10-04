extends Control


# ==========================================
# SIGNAL
# ==========================================

signal retry_requested
signal main_menu_requested


# ==========================================
# NODE RESULT
# ==========================================

@onready var time_result: Label = $TimeResult
@onready var crystal_result: Label = $CrystalResult
@onready var score_result: Label = $ScoreResult
@onready var height_result: Label = $HeightResult


# ==========================================
# BUTTON
# ==========================================

@onready var retry_button: TextureButton = $RetryButton
@onready var main_menu_button: TextureButton = $MainMenuButton


# ==========================================
# READY
# ==========================================

func _ready():

	# Awal game disembunyikan
	visible = false

	# Tetap bisa diklik walaupun game pause
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


# ==========================================
# SHOW GAME OVER
# ==========================================

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

	height_result.text = str(height) + " M"

	visible = true


# ==========================================
# RETRY
# ==========================================

func _on_retry_pressed():

	get_tree().paused = false

	retry_requested.emit()


# ==========================================
# MAIN MENU
# ==========================================

func _on_main_menu_pressed():

	get_tree().paused = false

	main_menu_requested.emit()
