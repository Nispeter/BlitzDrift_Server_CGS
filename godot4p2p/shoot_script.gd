extends Node2D

#OLD SCRIPT, IT WAS INTEGRATED TO "movement.gd"

@export var shoot_cooldown: float = 0.5 # Not sure about using floats for time
@export var last_shot_time: float = 0.0

@export var bullet_spawn_offset: Vector2 = Vector2(0, -20) # For now I'm just making them only shoot upwards (Negative Y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and (Time.get_ticks_msec() - last_shot_time > shoot_cooldown * 1000):
		last_shot_time = Time.get_ticks_msec()
		var bullet_position = global_position + bullet_spawn_offset
		rpc_id(1, "shoot_bullet", bullet_position, multiplayer.get_unique_id())
