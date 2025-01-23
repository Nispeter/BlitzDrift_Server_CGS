extends Node2D

@export var PlayerScene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = 0
	print(GameManager.Players.size())
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		print("Adding player " + currentPlayer.name)
		add_child(currentPlayer)
		for Spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if Spawn.name == str(index):
				currentPlayer.global_position = Spawn.global_position
		index += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
