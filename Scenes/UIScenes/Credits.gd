extends Label

func _ready():
	var tw = create_tween().set_loops().set_parallel().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "position:x", 1.5, 2).from_current().set_trans(Tween.TRANS_LINEAR)
