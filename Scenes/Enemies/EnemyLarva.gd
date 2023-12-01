extends "res://Scenes/Enemies/enemies.gd"

func _ready():
	var enemy
	for enemy_item in GameData.enemies:
		if(enemy_item["name"] == "EnemyLarva"):
			enemy = enemy_item
			break
	
	base_damage = enemy["base_damage"]
	coin_amount =  enemy["coin_amount"]
	speed = enemy["speed"]
	hp = enemy["hp"]
