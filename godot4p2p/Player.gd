extends Node

var id : int
var myname : String
func new(id,name):
	id = id
	myname = name
	return {"id": id, "name": myname}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
