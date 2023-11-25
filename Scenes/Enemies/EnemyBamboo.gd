extends PathFollow2D

@onready var _animated_sprite = get_node("CharacterBody2D").get_node('AnimatedSprite2D')

var speed = 0.5
var last_position = Vector2(0, 0)

func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed + delta)
	var current_position = position

	if(last_position != current_position):
		if(abs(last_position.x) < abs(current_position.x)): # Going Right
			_animated_sprite.play('east')
		if(abs(last_position.x) > abs(current_position.x)): # Going Left
			_animated_sprite.play('west')

		if(abs(last_position.y) < abs(current_position.y)): # Going down
			_animated_sprite.play('south')
		if(abs(last_position.y) > abs(current_position.y)): # Going up
			_animated_sprite.play('north')

		last_position = current_position

