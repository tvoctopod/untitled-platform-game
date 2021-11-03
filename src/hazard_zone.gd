extends StaticBody2D
tool

export (int) var damage = 100
export (Vector2) var size = Vector2(40, 2) setget set_size

# flag needed for setget
var ready = false

func _ready():
    # create a new rectangle shape for the collision
    # this is to ensure individual zones can have different sized shapes
    $collision.shape = RectangleShape2D.new()

    ready = true

    # manually call set_size for the editor
    set_size(size)

# Gets the respawn point to send players after they die to this hazard.
#
# If no respawn point exists, the player will respawn at the start point.
func get_respawn_point() -> Vector2:
    if get_node_or_null("respawn"):
        return $"respawn".global_position
    elif not Engine.editor_hint:
        return Game.get_start_point()
    else:
        return Vector2.ZERO
    
func set_size(new_size):
    size = new_size
    if ready:
        $collision.position = (size * 16)
        $collision.shape.extents = (size * 16)
        update()

func _process(delta):
    if Engine.editor_hint:
        update()
    
# debug visuals
func _draw():
    if Engine.editor_hint:
        var color = Color(1.0, 0.0, 0.0)  # red

        # outline the collision box
        Util.draw_zone(self, color)

        # draw a line from the collision box to the respawn point
        var respawn_point = to_local(get_respawn_point())
        draw_arc(respawn_point, 32, 0, 2 * PI, 20, color, 4) 
        draw_line(size * 16, respawn_point, color, 4)