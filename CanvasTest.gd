extends Node2D

@export var node : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



var viewportSize : Vector2
var playerPosition : Vector2
var playerLastPosition : Vector2
var playerMovement : Vector2
var omega = 4.0
var velocity = 100.0
var playerRotation = randf_range(0, 2*PI)
var playerLastRotation = playerRotation
var playerWidth = 5
var gapSpacingTimer = 0
var gapLengthTimer = 0

func get_input(): 
	var rotation_direction = Input.get_axis("left", "right")
	return rotation_direction
	
func move(delta):	
	playerRotation += omega * get_input() * delta
	playerMovement = velocity * delta * Vector2(cos(playerRotation), sin(playerRotation))
	playerPosition += playerMovement
	
	gapSpacingTimer -= delta
	gapLengthTimer -= delta
	
	if gapSpacingTimer < 0:
		var widthEquivalents = playerWidth / velocity
		gapLengthTimer = randf_range(widthEquivalents * 1.5, widthEquivalents * 4)
		gapSpacingTimer = randf_range(widthEquivalents * 10, widthEquivalents * 80)
		
	
var init = false

var root_view_image : Image

func detectCollision():	
	var radius = playerWidth / 2
	if (playerPosition.x < radius or 
	playerPosition.y < radius or
	viewportSize.x - playerPosition.x < radius or
	viewportSize.y - playerPosition.y < radius):
		return true
	var testRadius = radius + 1
	for y in range(-radius, radius):
		var x = sqrt(testRadius*testRadius - y*y)
		var offset = Vector2(x, y).rotated(playerRotation)
		var testPos = playerPosition + offset
		if (testPos.x < 0 or testPos.y < 0 or 
		testPos.x > viewportSize.x or testPos.y > viewportSize.y):
			return true
		var pixel = root_view_image.get_pixel(testPos.x, testPos.y)		
		#print(pixel)
		if pixel != Color.BLACK:
			return true
		
	return false

var dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport : SubViewport
	viewport = node.get_viewport()
	RenderingServer.viewport_set_clear_mode(viewport.get_viewport_rid(), RenderingServer.VIEWPORT_CLEAR_NEVER)
	var root_view_tex = viewport.get_texture()
	root_view_image = root_view_tex.get_image()
	viewportSize = get_viewport_rect().size
	
	if not init:
		playerPosition = Vector2(randf_range(viewportSize.x * 0.2, viewportSize.x*0.8)
		, randf_range(viewportSize.y*0.2, viewportSize.y*0.8))
		playerLastPosition = playerPosition
		init = true	
	var steps = ceil(delta * velocity / 3.0)#check every 3 pixels
	playerLastRotation = playerRotation
	playerLastPosition = playerPosition
	for i in range(steps):
		if not dead:
			deadTimer = 5 / velocity
			dead = detectCollision()
		if deadTimer > 0:
			move(delta / steps)
			
	if dead:
		deadTimer -= delta
		print("Dead")
	queue_redraw()
	pass
	
var deadTimer = 0.05

func _draw():
	if gapLengthTimer > 0:
		return
	if playerLastRotation == playerRotation:
		draw_line(playerPosition, playerLastPosition, Color.GREEN, playerWidth)
		#var x = 2
	else:
		var radius = velocity / omega
		var dir = sign(playerRotation - playerLastRotation)
		var center = playerPosition + radius * dir * playerMovement.normalized().rotated(PI/2)
		#draw_circle(center, 2, Color.HOT_PINK)		
		var rotStart = playerLastRotation-dir*PI/2
		var rotEnd = playerRotation-dir*PI/2*0.99#0.99 to make segments overlap better
		draw_arc(center, radius, rotStart, rotEnd, 20, Color.GREEN, playerWidth)
	draw_circle(playerPosition, playerWidth / 2 - 0.5, Color.GREEN)
	pass
