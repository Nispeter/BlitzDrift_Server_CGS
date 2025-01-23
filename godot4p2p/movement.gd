extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

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
	
@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position
