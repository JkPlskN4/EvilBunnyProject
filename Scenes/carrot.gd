extends Area2D
#@onready var player := get_tree().get_first_node_in_group("heroes")

func _process(delta: float) -> void:
	position.y += sin(Time.get_ticks_msec()/200.0) * 10 * delta
func _on_body_entered(body: Node2D) -> void:
	#player.hlth += 50
	if "hlth" in body and body.hlth < 100:
		body.hlth += 50
		$pickup.play()
		$sprite2d.visible = false
		set_deferred("$CollisionShape2D.disabled",true)
		await $pickup.finished
		queue_free()
