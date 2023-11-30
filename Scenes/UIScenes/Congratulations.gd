extends CanvasLayer

signal main_menu(condition)
signal start_infinity(condition)

func _ready():
	get_tree().paused = true

func _on_leave_pressed():
	get_tree().quit()

func _on_play_again_pressed():
	main_menu.emit(true)

func _on_infinity_pressed():
	start_infinity.emit()
