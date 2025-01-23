extends Control

@export var Address = "localhost"
@export var port = 9999
var peer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	pass # Replace with function body.

### Connection Handlers

# Called on server and clients when someone connects
func peer_connected(id):
	print("Player Connected " + str(id))
# Called on server and clients when someone disconnects
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
# Called only from clients on connect to server
func connected_to_server():
	print("Connected to Server")
	SendPlayerInformation.rpc_id(1, "", multiplayer.get_unique_id())
# Called only from clients on connection failed
func connection_failed():
	print("Connection failed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
@rpc("any_peer")
func SendPlayerInformation(name,id):
	if !GameManager.Players.has(id):
		print("No player with " + str(id) + " found!")
		GameManager.Players[id] = {
			"name": name,
			"id": id,
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
### Handles users interactions
func _on_host_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	# Now listening to port, if an error occurs it will return anything but OK
	var error = peer.create_server(port)
	if error != OK:
		print("Error: "+ error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Host ready")
	SendPlayerInformation("Host", multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_join_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_game_pressed() -> void:
	_start_game.rpc()
	pass # Replace with function body.
@rpc("any_peer","call_local")
func _start_game():
	var scene = load("res://main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
