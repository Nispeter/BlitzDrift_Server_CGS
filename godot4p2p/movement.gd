extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var shoot_cooldown: float = 0.5 # Not sure about using floats for time
@export var bullet_spawn_offset: Vector2 = Vector2(0, -20) # For now I'm just making them only shoot upwards (Negative Y)

var last_shot_time: float = 0.0

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	print(str(name) + " connected")
	$Name.text = str(name)

func _physics_process(delta: float) -> void:
	# Handle jump.
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		#print("I can move " + name)
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_vector("left", "right", "up", "down")
		if direction:
			velocity = direction * SPEED
			#rpc("remote_set_position", global_position)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			#rpc("remote_set_position", global_position)
		
		move_and_slide()
		
		# Handle shooting
		if Input.is_action_just_pressed("shoot") and Time.get_ticks_msec() - last_shot_time > shoot_cooldown * 1000:
			last_shot_time = Time.get_ticks_msec()
			var bullet_position = global_position + bullet_spawn_offset
			print("Client attempting to shoot from position:", bullet_position)
			rpc("shoot_bullet", bullet_position, multiplayer.get_unique_id())
			print(multiplayer.get_unique_id())
	
@rpc("any_peer", "call_local")
func shoot_bullet(position: Vector2, shooter_peer_id: int):
	print("Client received bullet spawn at position:", position, "from peer:", shooter_peer_id)

	var bullet = preload("res://bullet.tscn").instantiate()

	bullet.global_position = position
	print("Player global position:", global_position)
	print("Bullet spawn position:", position)
	bullet.authority = 1 # Redundant?
	get_tree().root.add_child(bullet) # Add globally

@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position
