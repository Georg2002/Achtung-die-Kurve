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
				var k = (2 + player.deadTimer)
				draw_circle(player.playerPosition, player.playerWidth / 2 * k, color, true, -1, true)
		else:
			draw_circle(player.playerPosition, player.playerWidth / 2 , Color.WHITE, true, -1, true)
			var radiusOffset = 5
			for item in player.items:
				if item.transientType:
					continue#no need to signal this
				var startAngle : float = -PI / 2
				var endAngle : float = -PI / 2
				var angle = item.getRemainingRatio() * 2 * PI
				var color : Color
				if item.effectType == Item.EffectTypes.NEGATIVE:
					startAngle += angle
					endAngle += 0
					color = Color.LIGHT_CORAL
				else:
					startAngle += 0
					endAngle += angle
					if item.effectType == Item.EffectTypes.POSITIVE:
						color = Color.LIGHT_GREEN
					else:
						color = Color.LIGHT_BLUE
				draw_arc(player.playerPosition, player.playerWidth + radiusOffset
				, startAngle, endAngle, 20, Color(color, 0.7), 3, true )
				radiusOffset += 7
