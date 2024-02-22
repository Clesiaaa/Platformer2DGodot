extends Label

func _process(delta):
	self.text = str("coins : ") + str(get_parent().money)
