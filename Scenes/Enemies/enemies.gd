extends PathFollow2D

signal base_damage_signal
signal coin_amount_signal

@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var impact_area = get_node("Impact")
var knight_impact = preload("res://Scenes/SupportScenes/Impact/KnightImpact.tscn")
var mage_impact = preload("res://Scenes/SupportScenes/Impact/MageImpact.tscn")

var impactData = {
	"TowerKnight": knight_impact,
	"TowerMage": mage_impact
}

var base_damage = 1
var coin_amount = 1
var speed = 0.5
var hp = 50
var last_position = Vector2(0, 0)
var max_hp = hp

func _physics_process(delta):
	if progress_ratio > 0.99:
		base_damage_signal.emit(base_damage)
		queue_free()
	move(delta)

func move(delta):
	set_progress(get_progress() + speed + delta)
	var current_position = position

	if(abs(last_position.x) != abs(current_position.x) || abs(last_position.y) != abs(current_position.y)):
		if(abs(last_position.x) < abs(current_position.x)): # Going Right
			animated_sprite.play('east')
		if(abs(last_position.x) > abs(current_position.x)): # Going Left
			animated_sprite.play('west')

		if(abs(last_position.y) < abs(current_position.y)): # Going down
			animated_sprite.play('south')
		if(abs(last_position.y) > abs(current_position.y)): # Going up
			animated_sprite.play('north')

		last_position = current_position

func on_hit(damage, tower_type):
	impact(tower_type)
	hp -= damage
	if hp <= max_hp/2.0:
		animated_sprite.modulate = Color("bb243dd9")
	if hp <= 0:
		on_destroy()

func impact(tower_type):
	randomize()
	var x_pos = randi() % 11
	randomize()
	var y_pos = randi() % 11
	var impact_location = Vector2(x_pos,y_pos)
	var new_impact = impactData[tower_type].instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy():
	coin_amount_signal.emit(coin_amount)
	get_node("CharacterBody2D").queue_free()
	await get_tree().create_timer(0.2, false).timeout
	self.queue_free()
