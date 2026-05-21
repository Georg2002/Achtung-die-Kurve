class_name Item

enum EffectTypes {POSITIVE, NEGATIVE, UNIVERSAL}

var id : int
var timer : float

var texture : ImageTexture
var position : Vector2
var effectType : EffectTypes
static var size : Vector2 = Vector2(32, 32)
var transientType : bool = false

func apply(_player : Wurm) -> void:
	pass

func unapply(_player : Wurm) -> void:
	pass

var timerMax : float = 1

func doTimestep(delta : float) -> void:
	timerMax = max(timerMax, timer)
	timer -= delta
	
func getRemainingRatio() -> float:
	return timer / timerMax

func isFinished() -> bool:
	return timer < 0

static var ItemTypes = [ItemClear, ItemNoBorder, ItemThinPositive, ItemThinNegative
, ItemFatPositive, ItemFatNegative, ItemFastPositive]
static func getRandomItem() -> Item:
	return ItemTypes[randi_range(0, ItemTypes.size() - 1)].new()
	
