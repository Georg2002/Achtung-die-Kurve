extends Node2D

@export var primaryNode : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func _draw():
	for player in primaryNode.players:
		#draw_circle(player.playerPosition, player.playerWidth / 2, player.color)
		draw_circle(player.playerPosition, player.playerWidth / 2 , Color.WHITE, true, -1, true)
