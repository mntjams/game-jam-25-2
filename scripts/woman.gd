extends Npc
class_name InteractableWoman
signal approached_by_player(woman : InteractableWoman)
signal player_left(woman : InteractableWoman)

func on_done_in_room() -> void:
	super.on_done_in_room()
	print("I am a woman woohooo")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("approached_by_player",self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("player_left",self)
