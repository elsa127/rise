extends Node2D


# ==========================================
# HUD
# ==========================================

@onready var diamond_label: Label = $HUD/DiamondLabel

@onready var heart1: CanvasItem = $HUD/Heart1
@onready var heart2: CanvasItem = $HUD/Heart2
@onready var heart3: CanvasItem = $HUD/Heart3

@onready var timer_label: Label = $HUD/TimerLabel
@onready var height_label: Label = $HUD/HeightLabel


# ==========================================
# PLAYER
# ==========================================

@onready var player: CharacterBody2D = $PlayerNara


# ==========================================
# RESULT UI
# ==========================================

@onready var level_complete_ui = $HUD/LevelCompleteUI
@onready var game_over_ui = $HUD/GameOverUI


# ==========================================
# DIAMOND
# ==========================================

var diamonds_collected: int = 0
var total_diamonds: int = 0


# ==========================================
# HEALTH
# ==========================================

var lives: int = 3

# Supaya satu sentuhan duri tidak mengurangi
# hati berkali-kali dalam waktu sangat cepat
var can_take_damage: bool = true

const DAMAGE_COOLDOWN: float = 1.0


# ==========================================
# TIMER
# ==========================================

var time_left: float = 60.0
var timer_finished: bool = false


# ==========================================
# HEIGHT
# ==========================================

var start_player_y: float = 0.0


# ==========================================
# STATUS LEVEL
# ==========================================

var level_finished: bool = false


# ==========================================
# READY
# ==========================================

func _ready():

	# ------------------------------------------
	# DIAMOND
	# ------------------------------------------

	var diamonds = get_tree().get_nodes_in_group("diamond")

	total_diamonds = diamonds.size()

	for diamond in diamonds:
		if diamond.has_signal("collected"):
			diamond.collected.connect(
				_on_diamond_collected
			)

	update_diamond_ui()


	# ------------------------------------------
	# HEALTH
	# ------------------------------------------

	lives = 3
	can_take_damage = true

	update_health_ui()


	# ------------------------------------------
	# TIMER
	# ------------------------------------------

	update_timer_ui()


	# ------------------------------------------
	# HEIGHT
	# ------------------------------------------

	start_player_y = player.global_position.y

	update_height_ui()


	# ------------------------------------------
	# LEVEL COMPLETE UI
	# ------------------------------------------

	level_complete_ui.next_level_requested.connect(
		_on_next_level_requested
	)

	level_complete_ui.main_menu_requested.connect(
		_on_level_complete_main_menu_requested
	)


	# ------------------------------------------
	# GAME OVER UI
	# ------------------------------------------

	game_over_ui.retry_requested.connect(
		_on_retry_requested
	)

	game_over_ui.main_menu_requested.connect(
		_on_game_over_main_menu_requested
	)


# ==========================================
# PROCESS
# ==========================================

func _process(delta):

	if level_finished:
		return

	update_timer(delta)
	update_height_ui()


# ==========================================
# DIAMOND
# ==========================================

func _on_diamond_collected():

	if level_finished:
		return

	diamonds_collected += 1

	update_diamond_ui()

	print(
		"Diamond: ",
		diamonds_collected,
		"/",
		total_diamonds
	)


	if diamonds_collected >= total_diamonds:
		print("SEMUA DIAMOND TERKUMPUL!")


func update_diamond_ui():

	diamond_label.text = (
		str(diamonds_collected)
		+ "/"
		+ str(total_diamonds)
	)


# ==========================================
# HEALTH
# ==========================================

func take_damage(amount: int = 1):

	if level_finished:
		return


	# Sedang kebal sementara
	if not can_take_damage:
		return


	can_take_damage = false


	# Kurangi nyawa SATU KALI
	lives -= amount


	if lives < 0:
		lives = 0


	update_health_ui()


	print("Nyawa sekarang: ", lives)


	# ------------------------------------------
	# NYAWA HABIS
	# ------------------------------------------

	if lives <= 0:

		print("NYAWA HABIS!")

		show_game_over("HEALTH")

		return


	# ------------------------------------------
	# DAMAGE COOLDOWN
	# ------------------------------------------

	await get_tree().create_timer(
		DAMAGE_COOLDOWN
	).timeout


	# Jangan aktifkan damage lagi kalau level
	# ternyata sudah selesai saat menunggu
	if level_finished:
		return


	can_take_damage = true


func update_health_ui():

	heart1.visible = lives >= 1
	heart2.visible = lives >= 2
	heart3.visible = lives >= 3


# ==========================================
# TIMER
# ==========================================

func update_timer(delta):

	if time_left <= 0:
		return


	time_left -= delta


	if time_left <= 0:

		time_left = 0


		if not timer_finished:

			timer_finished = true

			print("WAKTU HABIS!")

			show_game_over("TIME")


	update_timer_ui()


func update_timer_ui():

	var total_seconds: int = int(
		ceil(time_left)
	)


	var minutes: int = int(
		total_seconds / 60.0
	)


	var seconds: int = (
		total_seconds % 60
	)


	timer_label.text = "%02d:%02d" % [
		minutes,
		seconds
	]


# ==========================================
# HEIGHT
# ==========================================

func update_height_ui():

	var distance_up: float = (
		start_player_y
		- player.global_position.y
	)


	if distance_up < 0:
		distance_up = 0


	var height: int = int(
		distance_up / 10.0
	)


	height_label.text = str(height)


# ==========================================
# WAKTU HASIL
# ==========================================

func get_elapsed_time_text() -> String:

	var elapsed_time: float = (
		60.0
		- time_left
	)


	var total_seconds: int = int(
		elapsed_time
	)


	var minutes: int = int(
		total_seconds / 60.0
	)


	var seconds: int = (
		total_seconds % 60
	)


	return "%02d:%02d" % [
		minutes,
		seconds
	]


# ==========================================
# HEIGHT HASIL
# ==========================================

func get_current_height() -> int:

	var distance_up: float = (
		start_player_y
		- player.global_position.y
	)


	if distance_up < 0:
		distance_up = 0


	return int(
		distance_up / 10.0
	)


# ==========================================
# SCORE
# ==========================================

func calculate_score() -> int:

	var diamond_score: int = (
		diamonds_collected * 1000
	)


	var time_score: int = int(
		time_left * 50
	)


	return (
		diamond_score
		+ time_score
	)


# ==========================================
# LEVEL COMPLETE
# ==========================================

func level_complete():

	if level_finished:
		return


	level_finished = true


	print("LEVEL 1 COMPLETE!")


	# Stop player
	player.velocity = Vector2.ZERO
	player.set_physics_process(false)


	var time_text: String = (
		get_elapsed_time_text()
	)


	var final_height: int = (
		get_current_height()
	)


	var score: int = (
		calculate_score()
	)


	level_complete_ui.show_result(
		time_text,
		diamonds_collected,
		total_diamonds,
		score,
		final_height
	)


	get_tree().paused = true


# ==========================================
# LAVA / ES
# LANGSUNG KALAH
# ==========================================

func instant_game_over():

	if level_finished:
		return


	print(
		"GAME OVER - NARA TERKENA LAVA ES!"
	)


	show_game_over("LAVA")


# ==========================================
# GAME OVER
# ==========================================

func show_game_over(reason: String):

	if level_finished:
		return


	level_finished = true


	print(
		"GAME OVER! Penyebab: ",
		reason
	)


	# Stop player
	player.velocity = Vector2.ZERO
	player.set_physics_process(false)


	var time_text: String = (
		get_elapsed_time_text()
	)


	var final_height: int = (
		get_current_height()
	)


	var score: int = (
		calculate_score()
	)


	game_over_ui.show_game_over(
		time_text,
		diamonds_collected,
		total_diamonds,
		score,
		final_height
	)


	get_tree().paused = true


# ==========================================
# RETRY
# ==========================================

func _on_retry_requested():

	get_tree().paused = false

	get_tree().reload_current_scene()


# ==========================================
# NEXT LEVEL
# ==========================================

func _on_next_level_requested():

	get_tree().paused = false

	print("NEXT LEVEL")


	# Nanti setelah level 2 jadi:
	#
	# get_tree().change_scene_to_file(
	#	"res://scene/level_2.tscn"
	# )


# ==========================================
# MAIN MENU DARI LEVEL COMPLETE
# ==========================================

func _on_level_complete_main_menu_requested():

	get_tree().paused = false

	print("MAIN MENU")


	# Nanti:
	#
	# get_tree().change_scene_to_file(
	#	"res://scene/main_menu.tscn"
	# )


# ==========================================
# MAIN MENU DARI GAME OVER
# ==========================================

func _on_game_over_main_menu_requested():

	get_tree().paused = false

	print("MAIN MENU")


	# Nanti:
	#
	# get_tree().change_scene_to_file(
	#	"res://scene/main_menu.tscn"
	# )
