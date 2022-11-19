extends Node2D
class_name Level
@tool

@export (String) var level_name = "untitled"

func _draw():
    if Engine.editor_hint:
        draw_start_point()
        
func _process(delta):
    if Engine.editor_hint:
        update()

# Get the start point of this level, or (0, 0) if the start point doesn't exist
func get_start_point(idx = 0) -> Vector2:
    if $"points/start":
        return $"points/start".global_position
    else:
        return Vector2.ZERO

# Draw a start point indicator at the start point.
func draw_start_point():
    var pt = get_start_point()
    var color = Color(1.0, 1.0, 1.0)
    var points = PackedVector2Array([
        pt + Vector2(0, 16), 
        pt + Vector2(-16, -16),
        pt + Vector2(16, -16),
        pt + Vector2(0, 16),
    ])
    draw_polyline(points, color, 4)

