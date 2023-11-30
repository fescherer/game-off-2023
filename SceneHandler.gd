extends Node

func _ready():
	load_main_menu()

func _on_main_menu_ready():
	pass

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	get_tree().paused = false
	var game_scene = load("res://Scenes/MainScenes/game.tscn").instantiate()
	game_scene.game_finished.connect(finished_game)
	add_child(game_scene)
	
func finished_game(result):
	if(result == Enums.gameState.win):
		var congratulations = load("res://Scenes/UIScenes/Congratulations.tscn").instantiate()
		congratulations.main_menu.connect(unload_game)
		congratulations.start_infinity.connect(start_infinity_mode)
		add_child(congratulations)
	elif(result == Enums.gameState.lost):
		var gameover = load("res://Scenes/UIScenes/GameOver.tscn").instantiate()
		gameover.main_menu.connect(unload_game)
		add_child(gameover)
	else:
		unload_game('')

func unload_game(_result):
	if(get_node("game")):
		get_node("game").queue_free()
	remove_scenes_finished()
	
	var main_menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
	main_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(main_menu)
	load_main_menu()
	
func load_main_menu():
	$MainMenu/M/VB/NewGame.pressed.connect(on_new_game_pressed)
	$MainMenu/M/VB/HB/Quit.pressed.connect(on_quit_pressed)

func remove_scenes_finished():
	if(has_node("CongratulationsScreen")):
		get_node("CongratulationsScreen").queue_free()
	if(has_node("GameOverScreen")):
		get_node("GameOverScreen").queue_free()

func on_quit_pressed():
	get_tree().quit()

func start_infinity_mode():
	remove_scenes_finished()
	get_tree().paused = false
	get_node("game").is_infinity_mode = true
