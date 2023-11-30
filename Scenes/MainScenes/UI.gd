extends CanvasLayer

@onready var hp_label = $HUD/MarginContainer/VBoxContainer/InfoBar/Life/Label
@onready var coin_label = $HUD/MarginContainer/VBoxContainer/InfoBar/Money/Label

func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Scenes/Towers/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("bb243dd9")
	
	var range_texture = Sprite2D.new()
	range_texture.position = Vector2(0,0)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("bb243dd9")
	range_texture.set_name("RangeIndicator")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control,true)
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/RangeIndicator").modulate = Color(color)

##
## Game Control functions
## 
func _on_pause_play_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		print('Entrou no paused')
		get_tree().paused = false
	elif not get_parent().is_wave_started:
		print('aqioo')
		get_parent().start_next_wave()
	elif not get_parent().is_wave_started and get_parent().is_infinity_mode:
		print('foiiiii')
		get_parent().start_next_wave()
	else:
		get_tree().paused = true

func _on_fastfoward_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 15.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(15.0)

func update_health(life):
	hp_label.text = str(life)
	
func update_coin(coin):
	coin_label.text = str(coin)
	
func update_wave_label(wave):
	var wave_label = "Wave " + str(wave)
	get_node("HUD/MarginContainer/VBoxContainer/WaveCounter").text = str(wave_label)
