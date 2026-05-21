extends Item

class_name ItemClear

func _init():
	self.texture = ImageTexture.create_from_image(Image.load_from_file("ItemClear.png"))
	self.effectType = EffectTypes.UNIVERSAL
	self.transientType = true
	pass

var redundant = false

func apply(_player : Wurm) -> void:
	self.timer = 10	

func unapply(_player : Wurm) -> void:
	pass
