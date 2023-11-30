extends CanvasLayer

signal main_menu(condition)

func _ready():
	get_tree().paused = true


func _on_leave_pressed():
	get_tree().quit()


func _on_play_again_pressed():
	main_menu.emit(true)

func change_wave_label(wave):
	$ColorRect/VBoxContainer/HBoxContainer/WaveCounter.text = str(wave)
