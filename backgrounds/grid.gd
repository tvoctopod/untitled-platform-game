class_name GridBackground extends Node2D


# factor of background movement to camera movement
@export var parallax: float = 0.5

@onready var origin: Vector2 = position  # reference to original position

@onready var offset = Vector2(0.0, 0.0)

func _process(delta):
    if GameState.has_method("get_camera"):
        position = origin + GameState.get_camera().focus

    offset.x = fmod(offset.x + (delta * 10), 64)
    offset.y = fmod(offset.y + (delta * 10), 64)
    $box.texture_offset = ((GameState.get_camera().focus * parallax) + offset).round()
    $box_2.texture_offset = (GameState.get_camera().focus * parallax * 0.5).round()
