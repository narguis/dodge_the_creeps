extends Area2D

#This signal will later be emited when the player gets hit
signal hit

#The speed property is exported so it can be overriden directly on the inspector
@export var speed = 400.0
@onready var animated_sprite = $AnimatedSprite2D
var screen_size = Vector2.ZERO

#This built-in function is ran every time the game starts and is responsible for "spawining" the player
func _ready():
	#This function gets the size of the game screen
	screen_size = get_viewport_rect().size
	#The character starts hidden (on the game menu)
	hide()

#Process defines how the character updates every frame, delta is the time since the last update and it's not always constant
func _process(delta):
	var velocity = Vector2.ZERO
	
#	if Input.is_action_just_pressed("move_right"):
#		direction.x += 1
#	if Input.is_action_just_pressed("move_leftt"):
#		direction.x -= 1
#
#	if Input.is_action_just_pressed("move_down"):
#		direction.y += 1
#	if Input.is_action_just_pressed("move_up"):
#		direction.y -= 1
#
#	if direction.length() > 1:
#		direction = direction.normalized()
	
	#This function receives the input map as an argument, and attaches each input to a vector operation
	#The normalized method makes it so the value of this input can never exceed 1
	#This is used to prevent the player from going faster when walking on diagonals since the
	#vector's value would be something like (1, 1).
	
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if velocity.length() > 0:
		velocity *= speed
		animated_sprite.play()
	else:
		animated_sprite.stop()

	#position is an internal value, in this case it's being calculated based on the direction * speed * time between frames
	position += velocity * delta
	
	#The clamp function makes sure a value is always between its second and third parameters, so the player's is positioned
	#inside the game screen at all times
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#This checks if the player is currently moving on the horizontal axis
	if velocity.x != 0:
		animated_sprite.animation = "right"
		#Moving in the x axis makes your character turn off their turn on the y axis
		#This happens to prevent your character from bein upside down while you walk sieways
		animated_sprite.flip_v = false
		#Since there is only one sprite, the flip_v method is used to invert the "right" animation over the y axis
		#To simulate an animation of going left
		animated_sprite.flip_h = velocity.x < 0
			
	#This checks if the player is currently moving on the vertical axis		
	elif velocity.y != 0:
		animated_sprite.animation = "up"
		
		#In this case, "down" is the positive part of the y axis
		animated_sprite.flip_v = velocity.y > 0



func _on_body_entered(body):
	#If a body enters (touches) the area of the player
	#The player will be hidden
	hide()
	#The hit signal will be emited
	hit.emit()
	#And its collision will be disabled to prevent more hits
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	#The player will be unhidden when the game starts
	#Since it already is on the screen, just hidden
	show()
	$CollisionShape2D.set_deferred("disabled", false)
