extends Node

var tower_data = {
	"TowerKnight": {
		"damage": 50,
		"rof": 1,
		"range": 48,
		"cost": 5,
	},
	"TowerMage": {
		"damage": 10,
		"rof": 1,
		"range": 128,
		"cost": 3,
	} 
}

var enemies = ["EnemyBamboo","EnemyButterfly", "EnemyTanuki", "BossTanuki", "EnemyLarva"]

var waves = {
	wave1 = [
#		["EnemyButterfly", 5],
#		["EnemyTanuki", 3],
#		["BossTanuki", 3],
#		["EnemyButterfly", 5],
#		["EnemyBamboo", 3],
		["EnemyLarva", 3],
	],
#	wave2 = [
##		["EnemyTanuki", 3],
##		["EnemyTanuki", 3],
##		["EnemyTanuki", 3],
##		["EnemyTanuki", 3],
#		["EnemyTanuki", 3],
#	]
}
