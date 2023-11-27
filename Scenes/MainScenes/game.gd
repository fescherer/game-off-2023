extends Node2D

signal game_finished(result)

var map_node

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_in_wave = 0

var base_health = 3
var base_coins = 0

func _ready():
	map_node = get_node("Map01")
	get_node("UI").update_health(base_health)
	get_node("UI").update_coin(base_coins)
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.name))

func _process(_delta): #Run every frame
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode:
		verify_and_build()

#
# Wave function
#
func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout ## time between waves
	spawn_enemies(wave_data)
	
func retrieve_wave_data():
	var wave_data = [["EnemyBamboo", 5],["EnemyBamboo", 3],["EnemyBamboo", 3],["EnemyBamboo", 3],["EnemyBamboo", 3]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.connect("base_damage_signal", on_base_damage)
		new_enemy.connect("coin_amount_signal", on_coin_amount)
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout

func on_base_damage(damage):
	print('teve dano')
	base_health -= damage
	if base_health <=0:
		emit_signal("game_finished", false)
	else:
		get_node("UI").update_health(base_health)
		
func on_coin_amount(amount):
	base_coins += amount
	get_node("UI").update_coin(base_coins)

#
# Building Functions
#
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = "Tower" + tower_type
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(0, current_tile):
		get_node("UI").update_tower_preview(tile_position, "077e2ed9")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "bb243dd9")
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
	#	Test to verfiy if player has enough cash
		var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.is_built = true
		new_tower.tower_type = build_type
		map_node.get_node("Towers").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 0, Vector2i(3,4), 0)
		#deduct cash
		#update cash label
		cancel_build_mode()
