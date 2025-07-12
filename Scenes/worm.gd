extends Area2D

#worm health
var hlth = 2

#worm movement parameters
@export var spd = 50
var dirx = 1

#when the bullet hits the worm
func _on_area_entered(area: Area2D) -> void:
	#cut the health
	hlth -= 1
	#play damage sound
	$damage.play()
	#kill the bullet
	area.queue_free()
	#explained in hero
	var twn = create_tween()
	twn.tween_property($AnimatedSprite2D,"material:shader_parameter/amount",1.0,0.0)
	twn.tween_property($AnimatedSprite2D,"material:shader_parameter/amount",0.0,0.1).set_delay(0.1)

func _process(delta: float) -> void:
	#check if hlth is 0
	chkdth()
	#move the worm accrding to direction and speed and delta
	position.x += spd * dirx * delta

#func for checking worm health
func chkdth():
	if hlth <=0:
		#wait for the sound to end
		await $damage.finished
		#remove node
		queue_free()

#func for a body that has a damaged function collides(player)
func _on_body_entered(body: Node2D) -> void:
	#we check to see if the damaged method is in the body we are colliding with
	if "damaged" in body:
		#then we call that method
		body.damaged(10)

#if the worm hits the wall using the wallcollider sensor
#change the direction and flip the sprite
func _on_wallcoll_body_entered(_body: Node2D) -> void:
	dirx *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

#if the right floor collider stop sensing the floor
#flip the worm to the left
func _on_r_gcoll_body_exited(_body: Node2D) -> void:
	dirx = -1
	$AnimatedSprite2D.flip_h = true

#if the left floor collider stop sensing the floor
#flip the worm to the right
func _on_l_gcoll_body_exited(_body: Node2D) -> void:
	dirx = 1
	$AnimatedSprite2D.flip_h = false
