extends CanvasLayer

#get the player from its group
@onready var player = get_tree().get_first_node_in_group('heroes')

func _process(_delta: float) -> void:
	$hlthcont/hlthbar.value = player.hlth
	$bullets/bltcnt.text = "bullets: " + str(player.bnum)
