extends Node2D

@export var primaryNode : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func _draw():
	for item in primaryNode.items:
		draw_texture_rect(item.texture, Rect2(item.position - item.size / 2, item.size), false)
	for player in primaryNode.players:
		if player.deadTimer < 0:#fade out dead player heads
			if -player.deadTimer < 1:#less than a second passed
				var color = Color(Color.WHITE, 1+player.deadTimer)
				var scale = (2 + player.deadTimer)
				draw_circle(player.playerPosition, player.playerWidth / 2 * scale, color, true, -1, true)
		else:
			draw_circle(player.playerPosition, player.playerWidth / 2 , Color.WHITE, true, -1, true)
