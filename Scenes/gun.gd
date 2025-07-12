extends Area2D

var touched = false
func _process(delta: float) -> void:
	#a coding way to make the gun move up and down
	#you can easily use animation player for that but i loved the idea so much
	#here we add the sine of the current time tick in msec to the y position
	#dividing the tick by 200 to make it work slower (needs to be way slower)
	#then multiplying by delta to make it smoother with different fps
	#lastly multiply by 10 to make bigger movement
	position.y += sin(Time.get_ticks_msec()/200.0) * 10 * delta

#triggers when a physics object with the type (body) enters the area of the gun
#bodies are staticbody2d and characterbody2d
#note that we set up the collision masks and layers so it only sees the player
func _on_body_entered(body: Node2D) -> void:
	if "gun" in body and "bnum" in body and not touched:
		body.bnum += 10
		touched = true
		#we play the pickup sound
		$pickup.play()
		#then instead of killing it immediatly we hide its sprite and collision and await for the sound to end before killing it so it actually plays
		$Sprite2D.hide()
		#this is a very important func that i will explain in the last line in this script
		set_deferred("$CollisionShape2D.disabled",true)
		await $pickup.finished
		queue_free()



#deferred is a func that helps in changin a property or call a function while the affected methods is still being used to make sure that>
#nothing is gonna be broken bcuz of the sudden change or deletion>
#set_deferred is a func used for properties and its syntax is simple, to use it see the formula in line 22 in this script
#call_deferred is a func used to call functions for example queue_free() (didnt learn its syntax yet)
