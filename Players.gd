class_name Wurm

var playerPosition : Vector2
var playerLastPosition : Vector2
var playerMovement : Vector2
var playerRotation : float
var playerLastRotation : float
var omega = 4.0
var velocity = 100.0
var playerWidth = 5
var gapSpacingTimer = 0
var gapLengthTimer = 0
var dead = false
var keyLeft : int
var keyRight : int
var color : Color
var name : String
var score : int = 0

func _init(playerName : String, playerColor : Color,  playerKeyLeft : int, playerKeyRight : int):
	self.name = playerName
	self.keyLeft = playerKeyLeft
	self.keyRight = playerKeyRight
	self.color = playerColor
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func get_input(): 
	return int(Input.is_key_pressed(self.keyRight)) - int(Input.is_key_pressed(self.keyLeft))

var items : Array[Item] = []

func move(delta):
		for item in items:
			if item.effectType == Item.EffectTypes.POSITIVE:#only these apply to a single player
				item.doTimestep(delta)
			if item.isFinished():
				items.remove_at(items.find(item))
				item.unapply(self)
	
		self.playerRotation += self.omega * self.get_input() * delta
		self.playerMovement = self.velocity * delta * Vector2(cos(self.playerRotation), sin(self.playerRotation))
		self.playerPosition += self.playerMovement
	
		self.gapSpacingTimer -= delta
		self.gapLengthTimer -= delta
	
		if gapSpacingTimer < 0:
			var widthEquivalents = playerWidth / velocity
			gapLengthTimer = randf_range(widthEquivalents * 1.5, widthEquivalents * 4)
			gapSpacingTimer = randf_range(widthEquivalents * 10, widthEquivalents * 80)
