extends Control

signal leave(condition)

func _on_back_pressed():
	leave.emit(true)
