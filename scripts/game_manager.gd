extends Node

var free_locations = []
var kompars_locations = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_loc(loc):
	free_locations.append(loc)
