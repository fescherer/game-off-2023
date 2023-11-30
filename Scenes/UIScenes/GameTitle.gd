extends Label

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
	
func start_tween():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_loops()
#	tween.tween_property(self,"add_theme_color_override:font_color",Color.RED, 2).from(Color.BLUE).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self,"position:x",0.0, 2).from(210.0).set_trans(Tween.TRANS_LINEAR)
#	tween.start()
	self.position
	self.add_theme_color_override("font_color", Color.RED)

