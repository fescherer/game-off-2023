extends Node2D

var direction = Vector2(0, 0)
var enemy_array = []
var is_built = false
var enemy
var tower_type
var is_ready = true

func _ready():
	if is_built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[tower_type]["range"]

func _physics_process(_delta):
	if enemy_array.size() != 0 && is_built:
		select_enemy()
		if not get_node("AnimationPlayer").is_playing():
			turn()
		if is_ready:
			fire()
	else:
		enemy = null

func turn():
	var target_position = enemy.position
	var character_position = global_position
	direction = (target_position - character_position).normalized()
	
	if(direction.x > abs(direction.y)):
		# East
		set_animation(3, 8, 0, 0.0)
	elif direction.x < -abs(direction.y):
		# West
		set_animation(2, -8, 0, 180.0)
	elif direction.y > abs(direction.x):
		# South
		set_animation(0, 0, 8, 90.0)
	else:
		# North
		set_animation(1, 0, -8, 270.0)
		
func set_animation(tower_frame, x, y, angle):
	var muzzle = get_node("Tower/Muzzle")
	muzzle.position.x = x
	muzzle.position.y = y
	muzzle.rotation_degrees = angle
	get_node("Tower").set_frame(tower_frame)

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		# Get total progress and path size, so if we have more than 1 path, the tower can choose the best path (Enemy with the sortest path and more progress)
		# Eg. totalPath1 = 420px / totalPath2 = 200px / progress = 30px
		# offsetPath1 = 420 - 30 = 390 / offsetPath2 = 200 - 30 = 170 // Same progress will get the sortest path
		# Eg 2. totalPath1 = 420px / totalPath2 = 200px / progressPath1 = 400 / progressPath2 = 30px
		# offsetPath1 = 420 - 400 = 20 / offsetPath2 = 200 - 30 = 170 // Enemy is more likely to finish at path1, so Towers shoots it
		# The lower the value, the likely to that enemy complete the path, that's why we get the min() insted max()
		enemy_progress_array.append(i.get_parent().get_curve().get_baked_length() - i.progress)
	var max_offset = enemy_progress_array.min()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	
func fire():
	is_ready = false
	run_animation()
	enemy.on_hit(GameData.tower_data[tower_type]["damage"], tower_type)
	await get_tree().create_timer(GameData.tower_data[tower_type]["rof"], false).timeout
	is_ready = true

func run_animation():
	get_node("AnimationPlayer").play("fire")

func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())


