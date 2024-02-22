extends Label

func _process(delta):
	self.text = str("speed: ") + str(get_parent().speed)
