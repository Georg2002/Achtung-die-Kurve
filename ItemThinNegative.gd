extends Item

class_name ItemThinNegative

func _init():
	self.texture = ImageTexture.create_from_image(Image.load_from_file("ItemThinNegative.png"))
	self.effectType = EffectTypes.NEGATIVE
	pass

func apply(player : Wurm) -> void:
	player.playerWidth /= 2
	player.velocity /= 2
	player.omega *= 1.2
	self.timer = 10
	pass

func unapply(player : Wurm) -> void:
	player.playerWidth *= 2
	player.velocity *= 2
	player.omega /= 1.2
	pass
