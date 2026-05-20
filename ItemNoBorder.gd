extends Item

class_name ItemNoBorder

func _init():
	self.texture = ImageTexture.create_from_image(Image.load_from_file("ItemNoBorder.png"))
	self.effectType = EffectTypes.UNIVERSAL
	pass

var redundant = false

func apply(player : Wurm) -> void:
	self.timer = 10
	
	if player.noborder:#already active
		var t = typeof(self)
		for item in player.items:
			if typeof(item) == t:
				item.timer = self.timer
		self.timer = -1#kill as soon as possible
		self.redundant = true	
	player.noborder = true

func unapply(player : Wurm) -> void:
	if not self.redundant:
		player.noborder = false
