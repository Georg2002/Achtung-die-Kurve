extends Node
var imager : Image

@export var arenaSprite : Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var image : Image
	image = Image.create(1000, 500, false, Image.FORMAT_RGB8)	
	image.fill(Color.AQUAMARINE)
	#image.save_png("res://dasda.png")
	var texture : ImageTexture
	texture = ImageTexture.create_from_image(image)
	arenaSprite.texture = texture
	arenaSprite.offset.x = texture.get_width() / 2
	arenaSprite.offset.y = texture.get_height() / 2
	imager = image

var position = Vector2(randi_range(0, 999), randi_range(0, 499))
var rotation = randf_range(0, 2*PI)
func _get_input(): 
	var rotation_direction = Input.get_axis("left", "right")
	return rotation_direction
	
func _move(delta):	
	rotation += 4 * _get_input() * delta
	position += 50 * delta * Vector2(cos(rotation), sin(rotation))
	position.x = clampf(position.x, 0, 999)
	position.y = clampf(position.y, 0, 499)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_move(delta)
	if imager.get_pixel(position.x, position.y) == Color.AQUAMARINE:
		imager.set_pixel(position.x, position.y, Color.RED)	
	else:
		print("dead")
	
	var texture = ImageTexture.create_from_image(imager)
	arenaSprite.texture = texture
	pass
