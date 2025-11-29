extends Label


func _on_player_no_woman_in_sight() -> void:
	visible = false

func _on_player_woman_entered_sight() -> void:
	visible = true
