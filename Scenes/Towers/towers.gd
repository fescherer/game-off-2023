extends Node2D

var direction = Vector2(0, 0)

func _physics_process(delta):
	turn()
	
func turn():
	var target_position = get_global_mouse_position()
	var character_position = global_position
	direction = (target_position - character_position).normalized()
	
	if(direction.x > abs(direction.y)):
		get_node("Tower").set_frame(3)
	elif direction.x < -abs(direction.y):
		get_node("Tower").set_frame(2)
	elif direction.y > abs(direction.x):
		get_node("Tower").set_frame(0)
	else:
		get_node("Tower").set_frame(1)
	
