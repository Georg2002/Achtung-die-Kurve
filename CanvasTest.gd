extends Node2D

@export var node : Node2D
@export var scoreLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
var viewport : SubViewport
var viewportSize : Vector2
var players : Array[Wurm] = [Wurm.new("Green", Color.GREEN, KEY_A, KEY_D), Wurm.new("Red", Color.RED, KEY_LEFT, KEY_RIGHT), Wurm.new("Blue", Color.BLUE, KEY_S, KEY_W)]

enum States {START, PAUSED, RUNNING, END, END_WAITFORCLEAR, CLEAR}
var stateVar = States.START
var roundNumber = 0
var roundWinner : String
	
var root_view_image : Image

func detectCollision(player : Wurm):		
	var radius = player.playerWidth / 2
	if (player.playerPosition.x < radius or 
	player.playerPosition.y < radius or
	viewportSize.x - player.playerPosition.x < radius or
	viewportSize.y - player.playerPosition.y < radius):
		return true
	for y in range(-radius, radius):
		var x = 2
		var offset = Vector2(x, y).rotated(player.playerRotation)
		var testPos = player.playerPosition + offset
		if (testPos.x < 0 or testPos.y < 0 or 
		testPos.x > viewportSize.x or testPos.y > viewportSize.y):
			return true
		var pixel = root_view_image.get_pixel(testPos.x, testPos.y)		
		#print(pixel)
		if pixel != Color.BLACK:
			print(pixel)
			return true		
	return false

func findPlayer(i : int):
	for player in players:
		if player.id == i:
			return player
			
func setLabels():
	scoreLabel.text = "Runde " + str(roundNumber)
	for player in players:
		scoreLabel.text += "\n" + player.name + ": " + str(player.score) + " Punkte"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(States.keys()[stateVar])
	
	var startPressed = Input.is_action_just_pressed("start")
	viewport = node.get_viewport()
	RenderingServer.viewport_set_clear_mode(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_CLEAR_NEVER)
	viewportSize = get_viewport_rect().size
	var root_view_tex = viewport.get_texture()
	root_view_image = root_view_tex.get_image()
		
	if stateVar == States.RUNNING:
		if startPressed:
			stateVar = States.PAUSED
			startPressed = false
		var playersAlive = players.size()
		for player in players:
			var steps = ceil(delta * player.velocity / 3.0)#check every 3 pixels			
			var deadTimer = 0.000
			player.playerLastRotation = player.playerRotation
			player.playerLastPosition = player.playerPosition
			for i in range(steps):
				if not player.dead:
					deadTimer = 5 / player.velocity
					player.dead = detectCollision(player)
				if deadTimer > 0:
					player.move(delta / steps)
				
			if player.dead:
				playersAlive -= 1
				deadTimer -= delta
				if playersAlive == 1:
					stateVar = States.END
						
	if stateVar == States.PAUSED and startPressed:
		stateVar = States.RUNNING
	
	if stateVar == States.END:		
		stateVar = States.END_WAITFORCLEAR
		for player in players:			
			if not player.dead:
				roundWinner = str(player.name)
				player.score += 1
		setLabels()
	
	
	if stateVar == States.START:	
		roundNumber += 1
		stateVar = States.PAUSED
		for player in players:
			player.dead = false	
			player.playerPosition = Vector2(randf_range(viewportSize.x * 0.2, viewportSize.x*0.8),
				randf_range(viewportSize.y*0.2, viewportSize.y*0.8))
			player.playerRotation = randf_range(0, 2* PI)
			player.playerLastRotation = player.playerRotation
			player.playerLastPosition = player.playerPosition
		setLabels()
		
	queue_redraw()

func _draw():
	if stateVar == States.CLEAR:
		draw_rect(get_viewport_rect(), Color.BLACK, true)
		stateVar = States.RUNNING
		return
	if stateVar == States.END_WAITFORCLEAR and Input.is_action_just_pressed("start"):
		draw_rect(get_viewport_rect(), Color.BLACK, true)
		stateVar = States.START
		return
		
	for player in players:
		if player.gapLengthTimer > 0:
			return
		if player.playerLastRotation == player.playerRotation:
			draw_line(player.playerPosition, player.playerLastPosition, player.color, player.playerWidth)
			#var x = 2
		else:
			var radius = player.velocity / player.omega
			var dir = sign(player.playerRotation - player.playerLastRotation)
			var center = player.playerPosition + radius * dir * player.playerMovement.normalized().rotated(PI/2)
			#draw_circle(center, 2, Color.HOT_PINK)		
			var rotStart = player.playerLastRotation-dir*PI/2
			var rotEnd = player.playerRotation-dir*PI/2*0.99#0.99 to make segments overlap better
			draw_arc(center, radius, rotStart, rotEnd, 20, player.color, player.playerWidth)	
	pass
