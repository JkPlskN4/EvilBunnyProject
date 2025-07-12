extends CharacterBody2D

#setting up player health and damage cooldown var
var hlth = 100
var dmg := true 

#setting up x axis movement variables
var dir_x := 0.0

#setting up facing direction var
var faceR : bool = true

#var for gun and shoot cooldown and bullet creation and for num of bullets
var shoot : bool = true
var gun := false
var bnum = 0
signal bull(pos:Vector2,face:bool)

#var for movement speed
@export var spd = 150

func _process(_delta: float) -> void:
	#calling input function and gravity function and animation and facing direction
	getinput()
	create_gravity()
	getanimation()
	face()
	#assigning charbody2d velocity var to x axis
	velocity.x = dir_x * spd
	#calling movement function for charbody2d
	move_and_slide()
	#when you die
	if hlth <0:
		get_tree().quit()
	if bnum <=0 : gun = false
	else : gun = true
	if hlth > 100:
		hlth = 100

#function for animations
func getanimation():
	#starting animation var
	var anim = 'Idle'
	
	#jumping animation set to var
	if not is_on_floor():
		anim = 'Jump'
	elif dir_x != 0 :
		anim = 'Walk'
	#adding gun to animations by adding _gun to the string name
	if gun :
		anim += '_gun'
	#setting the animation to the var
	$AnimatedSprite2D.animation = anim
	#checking for facing direction and changing it
	$AnimatedSprite2D.flip_h = not faceR

#function to change facing direction
func face():
	#checking for input direction ONLY while moving to keep standing direction
	if dir_x !=0 :
		faceR = (dir_x >= 0)

#function to read inputs
func getinput():
	#assign x axis var to input(check input map)
	dir_x = Input.get_axis("left", "right")
	#change y velocity for jumping input and making sure its on floor using builtin function
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= 300
		#make jump sound
		$Sound/jump.play()
	#checking for shoot input and making sure its cooled down and the player has a gun
	if Input.is_action_just_pressed("shoot") and shoot and gun:
		#emiiting signal to create a bullet(refer to level.gd)
		emit_signal("bull", global_position, faceR)
		#making shooting impossible and setting a timer to re enable it
		shoot = false
		$"timers/shoot cooldown".start()
		#making fire animation visible(using faceR to decide which one) and setting a timer to hide it after 0.1 sec
		$fireanim.get_child(faceR).show()
		$timers/fireanima.start()
		#playing shoot sound
		$Sound/Laser.play()
		#minus the bullet number
		bnum -= 1

#gravity nigga
func create_gravity():
	velocity.y += 20

#function for shooting cooldown
func _on_shoot_cooldown_timeout() -> void:
	shoot = true

#timer function to hide fire animation
func _on_fireanima_timeout() -> void:
	$fireanim.get_child(faceR).hide()

#when you get hit by am enemy
func damaged(amount) -> void:
	#we are making a tween to change the amount value for the mix in flicker shader(refer to flicker shader code)
	if dmg :
		#make dmg sound
		$Sound/damage.play()
		var twn = create_tween()
		twn.tween_property($AnimatedSprite2D,"material:shader_parameter/amount",1.0,0.0)
		#set delay makes this code work after the previous code
		twn.tween_property($AnimatedSprite2D,"material:shader_parameter/amount",0.0,0.1).set_delay(0.1)
		#cuts the health by the amount and disabling the dmg and starting the dmgcooldown timer
		hlth -= amount
		dmg = false
		$timers/dmgtimer.start()

#when your damage cooldown ends
func _on_dmgtimer_timeout() -> void:
	dmg = true
