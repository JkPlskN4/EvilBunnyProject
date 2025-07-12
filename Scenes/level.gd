extends Node2D

#getting bullet scene ready by loading it to a const
const bltscn :PackedScene = preload("res://Scenes/bullet.tscn")

#the signal when the player presses shoot
func _on_hero_bull(pos: Variant, face: Variant) -> void:
	#make a new instance of the bullet and assign it to variable "bullet"
	var bullet = bltscn.instantiate()
	#create a var to hold the direction of the bullet (i used it only to set the bullet offset)
	#then depending on the facing direction of the player, set the direction of the bullet
	var side := 1 if face else -1
	#add the bullet instance to the tree
	$Bullets.add_child(bullet)
	#set the bullet pos to the player pos
	bullet.position = pos
	#add h and v offset using the var holding the direction as 1 or -1
	bullet.position.x += 12 * side
	bullet.position.y += 2
	#set the moving direction of the bullet
	if face : bullet.dirR = 1
	else : bullet.dirR = -1
	#set the facing direction of the bullet's sprite (we used "not" bcuz the flip makes it left and face defaults to right)
	bullet.flip = not face
