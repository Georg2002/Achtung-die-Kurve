class_name Item

enum EffectTypes {POSITIVE, NEGATIVE, UNIVERSAL}

var id : int
var timer : float

var texture : ImageTexture
var position : Vector2
var effectType : EffectTypes
static var size : Vector2 = Vector2(32, 32)

func apply(_player : Wurm) -> void:
	pass

func unapply(_player : Wurm) -> void:
	pass

func doTimestep(delta : float) -> void:
	timer -= delta
	
func isFinished() -> bool:
	return timer < 0

static var ItemTypes = [ItemThinPositive, ItemThinNegative]#ItemFatPositive, ItemFatNegative
static func getRandomItem() -> Item:
	return ItemTypes[randi_range(0, ItemTypes.size() - 1)].new()
	
