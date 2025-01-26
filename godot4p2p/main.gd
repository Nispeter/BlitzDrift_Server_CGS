extends Node2D
# Object that handles all the Networking
var multiplayer_peer = ENetMultiplayerPeer.new()
var connected_peer_ids = []

const PORT = 4444
const ADDRESS = "localhost" # IP

func _on_host_pressed():
	#$NetworkInfo/NetworkSideDisplay.text = "Server"
	$MenuBar.visible = false
	multiplayer_peer.create_server(PORT) #LISTENING TO PORT
	multiplayer.multiplayer_peer = multiplayer_peer #Set the multiplayer_peer as the handler
	#$NetworkInfo/NetworkSideDisplay.text = str(multiplayer.get_unique_id()) # Everyone has a unique id
	
	add_player_character(1)
	
	# Signal that merges with the client unique id and indicates when player id is connected
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			# Remote procedure call => Calls a function on another player game
			# Searches for the same node where the rpc was called and executes the function of that node
			rpc("add_newly_connected_player_character", new_peer_id) 
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			add_player_character(new_peer_id)
	)
	
func _on_client_pressed():
	#$NetworkInfo/NetworkSideDisplay.text = "Client"
	$MenuBar.visible = false
	multiplayer_peer.create_client(ADDRESS, PORT) #CONNECT TO ADDRESS AND LISTEN TO PORT
	multiplayer.multiplayer_peer = multiplayer_peer #Set the multiplayer_peer as the handler
	#$NetworkInfo/NetworkSideDisplay.text = str(multiplayer.get_unique_id()) # Everyone has a unique id
	
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://pj.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	
@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

@rpc
func shoot_bullet(position: Vector2, shooter_peer_id: int):
	print("Server received shoot request from peer:", shooter_peer_id)
	print("Spawning bullet at position:", position)

	# Spawn bullet on all clients and server
	var bullet = preload("res://bullet.tscn").instantiate()
	if not bullet:
		print("Error: Bullet scene not found!")
		return
	bullet.global_position = position
	bullet.is_authority = shooter_peer_id == multiplayer.get_unique_id()
	add_child(bullet)

	print("Bullet spawned on server.")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
