extends Control


# =====================================================
# PATH SCENE
# =====================================================
# Kalau nama/path scene kamu berbeda,
# tinggal sesuaikan dua baris ini.

const MAIN_MENU_PATH: String = "res://scene/MainMenu.tscn"
const LEVEL_1_PATH: String = "res://scene/level_1.tscn"


# =====================================================
# CARD
# =====================================================

@onready var card1: Control = $Card1
@onready var card2: Control = $Card2
@onready var card3: Control = $Card3


# =====================================================
# BUTTON
# =====================================================

@onready var back_button: TextureButton = $BackButton

@onready var level1_button: TextureButton = $Card1/PlayButton
@onready var level2_button: TextureButton = $Card2/PlayButton
@onready var level3_button: TextureButton = $Card3/PlayButton


# =====================================================
# DIAMOND LABEL
# =====================================================

@onready var level1_diamond: Label = $Card1/DiamondLabel
@onready var level2_diamond: Label = $Card2/DiamondLabel
@onready var level3_diamond: Label = $Card3/DiamondLabel


# =====================================================
# LOCK CARD
# =====================================================

@onready var level2_lock: CanvasItem = (
	card2.find_child(
		"LockIcon",
		true,
		false
	) as CanvasItem
)

@onready var level3_lock: CanvasItem = (
	card3.find_child(
		"LockIcon",
		true,
		false
	) as CanvasItem
)


# =====================================================
# STAR LEVEL 1
# =====================================================

@onready var level1_star1: TextureRect = $Card1/Star1
@onready var level1_star2: TextureRect = $Card1/Star2
@onready var level1_star3: TextureRect = $Card1/Star3


# =====================================================
# STAR LEVEL 2
# =====================================================

@onready var level2_star1: TextureRect = $Card2/Star1
@onready var level2_star2: TextureRect = $Card2/Star2
@onready var level2_star3: TextureRect = $Card2/Star3


# =====================================================
# STAR LEVEL 3
# =====================================================

@onready var level3_star1: TextureRect = $Card3/Star1
@onready var level3_star2: TextureRect = $Card3/Star2
@onready var level3_star3: TextureRect = $Card3/Star3


# =====================================================
# PROGRESS BAR
# DICARI OTOMATIS DI SELURUH LEVEL SELECT
# =====================================================

@onready var tower_icon1: TextureRect = (
	find_child(
		"TowerIcon1",
		true,
		false
	) as TextureRect
)

@onready var tower_icon2: TextureRect = (
	find_child(
		"TowerIcon2",
		true,
		false
	) as TextureRect
)

@onready var progress_line1: CanvasItem = (
	find_child(
		"ProgressLine",
		true,
		false
	) as CanvasItem
)

@onready var progress_line2: CanvasItem = (
	find_child(
		"ProgressLine2",
		true,
		false
	) as CanvasItem
)

@onready var lock_progress: CanvasItem = (
	find_child(
		"LockProgress",
		true,
		false
	) as CanvasItem
)


# =====================================================
# TEXTURE
# ISI LEWAT INSPECTOR ROOT LevelSelect
# =====================================================

@export var active_progress_texture: Texture2D
@export var inactive_progress_texture: Texture2D

@export var active_star_texture: Texture2D
@export var inactive_star_texture: Texture2D


# =====================================================
# STATUS LEVEL
# =====================================================

var level1_unlocked: bool = true
var level2_unlocked: bool = false
var level3_unlocked: bool = false


# =====================================================
# CARD VISUAL
# =====================================================

const NORMAL_SCALE := Vector2(
	1.0,
	1.0
)

const HOVER_SCALE := Vector2(
	1.05,
	1.05
)

const NORMAL_COLOR := Color(
	1.0,
	1.0,
	1.0,
	1.0
)

const LOCKED_COLOR := Color(
	0.45,
	0.45,
	0.45,
	1.0
)

const SHINE_COLOR := Color(
	1.15,
	1.15,
	1.15,
	1.0
)


# =====================================================
# WARNA PROGRESS LINE
# =====================================================

const ACTIVE_LINE_COLOR := Color(
	1.0,
	0.78,
	0.18,
	1.0
)

const INACTIVE_LINE_COLOR := Color(
	0.55,
	0.55,
	0.55,
	1.0
)


# =====================================================
# READY
# =====================================================

func _ready():

	get_tree().paused = false


	# =================================================
	# BACA GAME PROGRESS
	# =================================================

	level1_unlocked = (
		GameProgress.is_level_unlocked(1)
	)

	level2_unlocked = (
		GameProgress.is_level_unlocked(2)
	)

	level3_unlocked = (
		GameProgress.is_level_unlocked(3)
	)


	print("==========================")
	print("LEVEL SELECT DIBUKA")
	print("LEVEL 1 OPEN: ", level1_unlocked)
	print("LEVEL 2 OPEN: ", level2_unlocked)
	print("LEVEL 3 OPEN: ", level3_unlocked)
	print("==========================")


	# =================================================
	# BUTTON SIGNAL
	# =================================================

	back_button.pressed.connect(
		_on_back_pressed
	)

	level1_button.pressed.connect(
		_on_level1_pressed
	)

	level2_button.pressed.connect(
		_on_level2_pressed
	)

	level3_button.pressed.connect(
		_on_level3_pressed
	)


	# =================================================
	# SETUP CARD
	# =================================================

	setup_card(card1)
	setup_card(card2)
	setup_card(card3)


	# =================================================
	# HOVER CARD
	# =================================================

	card1.mouse_entered.connect(
		_on_card1_mouse_entered
	)

	card1.mouse_exited.connect(
		_on_card1_mouse_exited
	)


	card2.mouse_entered.connect(
		_on_card2_mouse_entered
	)

	card2.mouse_exited.connect(
		_on_card2_mouse_exited
	)


	card3.mouse_entered.connect(
		_on_card3_mouse_entered
	)

	card3.mouse_exited.connect(
		_on_card3_mouse_exited
	)


	# =================================================
	# UPDATE UI
	# =================================================

	update_level_cards()

	update_all_stars()

	update_progress_bar()


# =====================================================
# SETUP CARD
# =====================================================

func setup_card(card: Control):

	card.pivot_offset = (
		card.size / 2.0
	)

	card.scale = NORMAL_SCALE


# =====================================================
# UPDATE SEMUA CARD
# =====================================================

func update_level_cards():

	update_level1_card()

	update_level2_card()

	update_level3_card()


# =====================================================
# LEVEL 1 CARD
# =====================================================

func update_level1_card():

	level1_button.disabled = (
		not level1_unlocked
	)


	if level1_unlocked:

		card1.modulate = NORMAL_COLOR


		var diamonds: int = (
			GameProgress.get_level_diamonds(1)
		)


		level1_diamond.text = (
			str(diamonds)
			+ "/5"
		)


	else:

		card1.modulate = LOCKED_COLOR

		level1_diamond.text = "????"


# =====================================================
# LEVEL 2 CARD
# =====================================================

func update_level2_card():

	level2_button.disabled = (
		not level2_unlocked
	)


	if level2_lock != null:

		level2_lock.visible = (
			not level2_unlocked
		)


	if level2_unlocked:

		card2.modulate = NORMAL_COLOR


		var diamonds: int = (
			GameProgress.get_level_diamonds(2)
		)


		level2_diamond.text = (
			str(diamonds)
			+ "/10"
		)


	else:

		card2.modulate = LOCKED_COLOR

		level2_diamond.text = "????"


# =====================================================
# LEVEL 3 CARD
# =====================================================

func update_level3_card():

	level3_button.disabled = (
		not level3_unlocked
	)


	if level3_lock != null:

		level3_lock.visible = (
			not level3_unlocked
		)


	if level3_unlocked:

		card3.modulate = NORMAL_COLOR


		var diamonds: int = (
			GameProgress.get_level_diamonds(3)
		)


		level3_diamond.text = (
			str(diamonds)
			+ "/15"
		)


	else:

		card3.modulate = LOCKED_COLOR

		level3_diamond.text = "????"


# =====================================================
# BINTANG
# =====================================================

func update_all_stars():

	var stars_level1: int = (
		GameProgress.get_level_stars(1)
	)

	var stars_level2: int = (
		GameProgress.get_level_stars(2)
	)

	var stars_level3: int = (
		GameProgress.get_level_stars(3)
	)


	update_star_set(
		level1_star1,
		level1_star2,
		level1_star3,
		stars_level1
	)


	update_star_set(
		level2_star1,
		level2_star2,
		level2_star3,
		stars_level2
	)


	update_star_set(
		level3_star1,
		level3_star2,
		level3_star3,
		stars_level3
	)


	print(
		"BINTANG LEVEL 1: ",
		stars_level1
	)

	print(
		"BINTANG LEVEL 2: ",
		stars_level2
	)

	print(
		"BINTANG LEVEL 3: ",
		stars_level3
	)


# =====================================================
# UPDATE SATU SET BINTANG
# =====================================================

func update_star_set(
	star1: TextureRect,
	star2: TextureRect,
	star3: TextureRect,
	earned_stars: int
):

	if active_star_texture == null:

		print(
			"ERROR: Active Star Texture belum diisi!"
		)

		return


	if inactive_star_texture == null:

		print(
			"ERROR: Inactive Star Texture belum diisi!"
		)

		return


	if earned_stars >= 1:

		star1.texture = (
			active_star_texture
		)

	else:

		star1.texture = (
			inactive_star_texture
		)


	if earned_stars >= 2:

		star2.texture = (
			active_star_texture
		)

	else:

		star2.texture = (
			inactive_star_texture
		)


	if earned_stars >= 3:

		star3.texture = (
			active_star_texture
		)

	else:

		star3.texture = (
			inactive_star_texture
		)


# =====================================================
# UPDATE PROGRESS BAR
# =====================================================

func update_progress_bar():

	print("==========================")
	print("UPDATE PROGRESS BAR")
	print("==========================")


	# =================================================
	# CEK NODE
	# =================================================

	if tower_icon1 == null:

		print(
			"ERROR: TowerIcon1 tidak ditemukan!"
		)


	if tower_icon2 == null:

		print(
			"ERROR: TowerIcon2 tidak ditemukan!"
		)


	if progress_line1 == null:

		print(
			"ERROR: ProgressLine tidak ditemukan!"
		)


	if progress_line2 == null:

		print(
			"ERROR: ProgressLine2 tidak ditemukan!"
		)


	if lock_progress == null:

		print(
			"ERROR: LockProgress tidak ditemukan!"
		)


	# =================================================
	# TOWER LEVEL 1
	# =================================================

	if tower_icon1 != null:

		if active_progress_texture != null:

			tower_icon1.texture = (
				active_progress_texture
			)


	# =================================================
	# LEVEL 1 → LEVEL 2
	# =================================================

	if level2_unlocked:

		# Tower 2 jadi aktif
		if tower_icon2 != null:

			if active_progress_texture != null:

				tower_icon2.texture = (
					active_progress_texture
				)


		# Garis menuju Level 2 aktif
		if progress_line1 != null:

			progress_line1.modulate = (
				ACTIVE_LINE_COLOR
			)


	else:

		# Tower Level 2 abu-abu
		if tower_icon2 != null:

			if inactive_progress_texture != null:

				tower_icon2.texture = (
					inactive_progress_texture
				)


		if progress_line1 != null:

			progress_line1.modulate = (
				INACTIVE_LINE_COLOR
			)


	# =================================================
	# LEVEL 2 → LEVEL 3
	# =================================================

	if level3_unlocked:

		# Garis Level 2 → Level 3 aktif
		if progress_line2 != null:

			progress_line2.modulate = (
				ACTIVE_LINE_COLOR
			)


		# Lock bawah hilang
		if lock_progress != null:

			lock_progress.visible = false


	else:

		# Garis masih belum aktif
		if progress_line2 != null:

			progress_line2.modulate = (
				INACTIVE_LINE_COLOR
			)


		# Lock Level 3 masih muncul
		if lock_progress != null:

			lock_progress.visible = true


# =====================================================
# CARD 1 HOVER
# =====================================================

func _on_card1_mouse_entered():

	card_hover(
		card1,
		level1_unlocked
	)


func _on_card1_mouse_exited():

	card_unhover(
		card1,
		level1_unlocked
	)


# =====================================================
# CARD 2 HOVER
# =====================================================

func _on_card2_mouse_entered():

	card_hover(
		card2,
		level2_unlocked
	)


func _on_card2_mouse_exited():

	card_unhover(
		card2,
		level2_unlocked
	)


# =====================================================
# CARD 3 HOVER
# =====================================================

func _on_card3_mouse_entered():

	card_hover(
		card3,
		level3_unlocked
	)


func _on_card3_mouse_exited():

	card_unhover(
		card3,
		level3_unlocked
	)


# =====================================================
# HOVER / SHINE
# =====================================================

func card_hover(
	card: Control,
	unlocked: bool
):

	if not unlocked:
		return


	var tween = create_tween()

	tween.set_parallel(true)


	tween.tween_property(
		card,
		"scale",
		HOVER_SCALE,
		0.12
	)


	tween.tween_property(
		card,
		"modulate",
		SHINE_COLOR,
		0.12
	)


# =====================================================
# UNHOVER
# =====================================================

func card_unhover(
	card: Control,
	unlocked: bool
):

	if not unlocked:
		return


	var tween = create_tween()

	tween.set_parallel(true)


	tween.tween_property(
		card,
		"scale",
		NORMAL_SCALE,
		0.12
	)


	tween.tween_property(
		card,
		"modulate",
		NORMAL_COLOR,
		0.12
	)


# =====================================================
# BACK → MAIN MENU
# =====================================================

func _on_back_pressed():

	print(
		"BACK → MAIN MENU"
	)


	get_tree().paused = false


	if not ResourceLoader.exists(
		MAIN_MENU_PATH
	):

		print(
			"ERROR: Main Menu tidak ditemukan: ",
			MAIN_MENU_PATH
		)

		return


	var error = (
		get_tree().change_scene_to_file(
			MAIN_MENU_PATH
		)
	)


	print(
		"HASIL PINDAH MAIN MENU: ",
		error
	)


# =====================================================
# LEVEL 1
# =====================================================

func _on_level1_pressed():

	if not level1_unlocked:
		return


	print(
		"MASUK LEVEL 1"
	)


	get_tree().paused = false


	if not ResourceLoader.exists(
		LEVEL_1_PATH
	):

		print(
			"ERROR: Level 1 tidak ditemukan: ",
			LEVEL_1_PATH
		)

		return


	var error = (
		get_tree().change_scene_to_file(
			LEVEL_1_PATH
		)
	)


	print(
		"HASIL PINDAH LEVEL 1: ",
		error
	)


# =====================================================
# LEVEL 2
# =====================================================

func _on_level2_pressed():

	if not level2_unlocked:

		print(
			"LEVEL 2 MASIH TERKUNCI!"
		)

		return


	print(
		"LEVEL 2 SUDAH TERBUKA!"
	)


	print(
		"SCENE LEVEL 2 BELUM DIBUAT."
	)


# =====================================================
# LEVEL 3
# =====================================================

func _on_level3_pressed():

	if not level3_unlocked:

		print(
			"LEVEL 3 MASIH TERKUNCI!"
		)

		return


	print(
		"LEVEL 3 SUDAH TERBUKA!"
	)


	print(
		"SCENE LEVEL 3 BELUM DIBUAT."
	)
