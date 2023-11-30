extends Node2D

signal game_finished(result, wave)

var map_node

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_in_wave = 0
var is_wave_started = false
var is_infinity_mode = false

var base_health = 3
var base_coins = 8

func _ready():
	map_node = get_node("Map01")
	get_node("UI").update_health(base_health)
	get_node("UI").update_coin(base_coins)
	prepare_bought_items()
	
	var coin_texture = load("res://Assets/UI/Coin22.png")
	for i in GameData.tower_data.keys():
		var tower_group = HBoxContainer.new()
		tower_group.set_name(i + "Group")
		tower_group.alignment = 1
		var button = TextureButton.new()
		button.set_name(i)
		var texture = load("res://Assets/Towers/" + i +"/faceset.png")
		button.texture_normal = texture
		button.add_to_group("build_buttons")
		button.pressed.connect(initiate_build_mode.bind(i))
		tower_group.add_child(button)
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 8)
		label.text = str(GameData.tower_data[i]["cost"])
		tower_group.add_child(label)
		var coin = TextureRect.new()
		coin.texture = coin_texture
		coin.stretch_mode = 2
		coin.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		coin.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		tower_group.add_child(coin)
		$UI/HUD/MarginContainer/VBoxContainer/VBoxContainer.add_child(tower_group)
		print(i)

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
	if is_infinity_mode:
		run_infinity_mode()
	else:
		is_wave_started = true
		var wave_data = retrieve_wave_data()
		get_node("UI").update_wave_label(current_wave)
		await get_tree().create_timer(0.2, false).timeout ## time between waves
		await spawn_enemies(wave_data)

	
func retrieve_wave_data():
	current_wave += 1
	var enemies = GameData.waves["wave"+str(current_wave)]
	enemies_in_wave = enemies.size()
	return enemies

func handle_enemy_wave():
	is_wave_started = false
	$UI/HUD/MarginContainer/VBoxContainer/Buttons/PausePlay.button_pressed = false
	if(current_wave == GameData.waves.values().size()):
		await get_tree().create_timer(0.5, false).timeout
		game_finished.emit(Enums.gameState.win, current_wave)

func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.connect("base_damage_signal", on_base_damage)
		new_enemy.connect("coin_amount_signal", on_coin_amount)
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(i[1], false).timeout
		

func run_infinity_mode():
	is_wave_started = true
	current_wave += 1
	get_node("UI").update_wave_label(current_wave)
	randomize()
	var quantity_of_enemies = randi()%GameData.enemies.size()+2
	var enemies = []
	for i in range(quantity_of_enemies):
		randomize()
		var enemy_index = randi()%GameData.enemies.size()
		randomize()
		var enemy_time = randi_range(0, 2)
		enemies.append([GameData.enemies[enemy_index], enemy_time])
	await spawn_enemies(enemies)
	await get_tree().create_timer(5, false).timeout ## time between waves
	run_infinity_mode()

func on_base_damage(damage):
	base_health -= damage
	enemies_in_wave -= 1
	if base_health <=0:
		get_node("UI").update_health(base_health)
		game_finished.emit(Enums.gameState.lost, current_wave)
		is_wave_started = false
	else:
		get_node("UI").update_health(base_health)
	if(not is_infinity_mode and enemies_in_wave == 0):
		print('perdeu, mas ganhou')
		handle_enemy_wave()

func on_coin_amount(amount):
	enemies_in_wave -= 1
	if(not is_infinity_mode and enemies_in_wave == 0):
		handle_enemy_wave()
	base_coins += amount
	get_node("UI").update_coin(base_coins)
	prepare_bought_items()

func prepare_bought_items():
	for i in get_tree().get_nodes_in_group("build_buttons"):
		var tower_cost = GameData.tower_data[i.name]['cost']
		if tower_cost >= base_coins + 1:
			i.modulate = Color("93321f")
		else:
			i.modulate = Color(1,1,1,1)
			

#
# Building Functions
#
func initiate_build_mode(tower_type):
	build_type = tower_type
	var tower_cost = GameData.tower_data[build_type]['cost']
	if build_mode:
		cancel_build_mode()
	
	if base_coins >= tower_cost:
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
		var tower_cost = GameData.tower_data[build_type]['cost']
		if base_coins >= tower_cost:
			var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate()
			new_tower.position = build_location
			new_tower.is_built = true
			new_tower.tower_type = build_type
			map_node.get_node("Towers").add_child(new_tower, true)
			map_node.get_node("TowerExclusion").set_cell(0, build_tile, 0, Vector2i(3,4), 0)
			base_coins -= tower_cost
			get_node("UI").update_coin(base_coins)
			prepare_bought_items()
			cancel_build_mode()
