extends Area2D
#2 vars for bullet direction and shape direction
var dirR :int = 1
var flip = 0
#editable var for bullet speed
@export var spd := 300
func _process(delta: float) -> void:
	#it adds movement that is absolute and not relative to the framerate using delta and then use dirR to change its direction
	position.x += spd * delta * dirR
	#use flip var edited in level.gd to set sprite direction
	$Sprite2D.flip_h = flip
