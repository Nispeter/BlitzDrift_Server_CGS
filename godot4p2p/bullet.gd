extends Node2D

@export var velocity: Vector2 = Vector2(0, -400) 
@export var lifespan: float = 5.0 

#var is_authority: bool = false ##################
var authority: int = 0 ## 1 is True, and 1 means host
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(lifespan).timeout
	print("Bullet expired!")
	queue_free() # Remove the bullet after its lifespan ends


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if authority == 1: # Server (Authority) is in charge of moving the bullets, NO ONE ELSE
		position += velocity * delta 
		rpc("update_position", global_position) # Server sents rpc to clients to update bullets

@rpc("unreliable")
func update_position(new_position: Vector2):
	if authority != 1: # Clients update the position based on the server
		global_position = new_position
