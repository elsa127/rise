extends Node


# ==========================================
# LEVEL YANG TERBUKA
# ==========================================

var unlocked_levels = {
	1: true,
	2: false,
	3: false
}


# ==========================================
# DIAMOND TERBAIK
# ==========================================

var level_diamonds = {
	1: 0,
	2: 0,
	3: 0
}


# ==========================================
# BINTANG TERBAIK
# ==========================================

var level_stars = {
	1: 0,
	2: 0,
	3: 0
}


# ==========================================
# LEVEL SELESAI
# ==========================================

func complete_level(
	level_number: int,
	diamonds: int,
	stars: int
):

	# Simpan diamond terbaik
	if diamonds > level_diamonds[level_number]:
		level_diamonds[level_number] = diamonds


	# Simpan bintang terbaik
	if stars > level_stars[level_number]:
		level_stars[level_number] = stars


	# Buka level berikutnya
	var next_level = level_number + 1

	if unlocked_levels.has(next_level):
		unlocked_levels[next_level] = true


	print(
		"Level ",
		level_number,
		" selesai!"
	)

	print(
		"Level berikutnya terbuka: ",
		next_level
	)


# ==========================================
# CEK LEVEL
# ==========================================

func is_level_unlocked(level_number: int) -> bool:

	return unlocked_levels.get(
		level_number,
		false
	)


# ==========================================
# AMBIL DIAMOND
# ==========================================

func get_level_diamonds(level_number: int) -> int:

	return level_diamonds.get(
		level_number,
		0
	)


# ==========================================
# AMBIL BINTANG
# ==========================================

func get_level_stars(level_number: int) -> int:

	return level_stars.get(
		level_number,
		0
	)
