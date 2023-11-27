extends Node

func _ready():
	load_main_menu()

func _on_main_menu_ready():
	pass

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/game.tscn").instantiate()
	game_scene.game_finished.connect(unload_game)
	add_child(game_scene)

func unload_game(result):
	get_node("game").queue_free()
	var main_menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
	add_child(main_menu)
	load_main_menu()
	
func load_main_menu():
	$MainMenu/M/VB/NewGame.pressed.connect(on_new_game_pressed)
	$MainMenu/M/VB/HB/Quit.pressed.connect(on_quit_pressed)
	
func on_quit_pressed():
	get_tree().quit()
