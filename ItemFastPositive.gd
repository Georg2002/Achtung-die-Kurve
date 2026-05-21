extends Item

class_name ItemFastPositive

func _init():
	self.texture = ImageTexture.create_from_image(Image.load_from_file("ItemFastPositive.png"))
	self.effectType = EffectTypes.POSITIVE
	pass

func apply(player : Wurm) -> void:
	player.velocity *= 1.5
	player.omega *= 1.5
	self.timer = 10
	pass

func unapply(player : Wurm) -> void:
	player.velocity /= 1.5
	player.omega /= 1.5
	pass
