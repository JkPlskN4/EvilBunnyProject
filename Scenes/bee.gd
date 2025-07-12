extends Area2D
#bee movement markers and target and which side its moving to(forward)
@export var marker1 : Marker2D
@export var marker2 : Marker2D
#we made it onready so the var only works when the bee is in the scene tree so it wont become empty
@onready var target = marker2
var forward := true
#bee speed
@export var spd = 30
#bee health
var hlth = 3
#var for the player so the bee can follow it
@onready var player = get_tree().get_first_node_in_group('heroes')
#vars for knockback
var knockback : Vector2 = Vector2.ZERO
var knockback_time : float = 0.0
var velocity : Vector2 = Vector2.ZERO
#when the bullet hits the bee
func _on_area_entered(area: Area2D) -> void:
	#hurt the bee
	hlth -= 1
	#play damage sound
	$damage.play()
	#kill the bullet
	area.queue_free()
	#explained in hero
	var twn = create_tween()
	twn.tween_property($AnimatedSprite2D,"material:shader_parameter/amount",1.0,0.0)
	twn.tween_property($AnimatedSprite2D,"material:shader_parameter/amount",0.0,0.1).set_delay(0.1)
	
#setting up the bee startin gposition
func _ready() -> void:
	position = marker1.position

func _process(delta: float) -> void:
	#check if hlth is 0
	chkdth()
	#call the target changing func
	targ()
	#move the bee according to the marker distance (normalize makes the vector speed 1 so it wont affect the bee speed)
	position += (target.position - position).normalized() * spd * delta
	#flip the sprite according to where the bee is looking
	$AnimatedSprite2D.flip_h = not forward

func _physics_process(delta: float) -> void:
	velocity = knockback
	if knockback_time > 0.0 :
		knockback_time -= delta
		if knockback_time <= 0.0:
			knockback = Vector2.ZERO
	position.x += velocity.x * delta
#func for the bee target movement
func targ():
	#if the bee is moving forward and its close to marker2(the forward marker)then make it the opposite
	#or if the opposite happens then make it back
	if forward and position.distance_to(marker2.position) < 10 or\
	not forward and position.distance_to(marker1.position) < 10:
		forward = not forward
		#if the bee is close to the player make it follow the player and if its closer to origin than the player then make it look forward (or the ooposite)
	if position.distance_to(player.position) < 80:
		target = player
		forward = player.position.x > position.x
	#if it is looking forward then make it follow marker 2 (and the opposite)
	elif forward: target = marker2
	else : target = marker1

#func for checking bee health
func chkdth():
	#if health is 0 kill bee
	if hlth <=0:
		#wait for the sound to end
		await $damage.finished
		queue_free()

#func for a body that has a damaged function collides(player)
func _on_body_entered(body: Node2D) -> void:
	#we check to see if the damaged method is in the body we are colliding with
	if "damaged" in body:
		#then we call that method
		body.damaged(20)
		#then we make knockback
		var dire = (body.global_position - global_position).normalized()
		knckback(dire * -1,150,0.12)
	

#func for applying knockbac
func knckback(direction:Vector2, force:float, duration:float):
	knockback = direction * force
	knockback_time = duration
