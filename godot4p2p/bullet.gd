extends Node2D

@export var velocity: Vector2 = Vector2(0, -400) 
@export var lifespan: float = 5.0 

var is_authority: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(lifespan).timeout
	print("Chao bullet")
	queue_free() # Remove the bullet after its lifespan ends


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_authority: # Server (Authority) is in charge of moving the bullets, NO ONE ELSE
		position += velocity * delta
