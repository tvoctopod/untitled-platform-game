#================================================================================
# Interactable
#
# A base class for a 2D area that,
# if a runner is inside and presses an interact key,
# calls the on_interact() method.
#
# If a runner leaves the 2D area or is finished interacting,
# the on_dismiss() method is called.
#================================================================================

class_name Interactable
extends Area2D

signal interact

var is_player_near = false
var is_interacting = false  # true if in the middle of an interaction

func _ready():
    connect("body_entered",Callable(self,"on_body_enter"))
    connect("body_exited",Callable(self,"on_body_exit"))

func on_body_enter(body):
    Game.get_player().get_node("interact_sprite").visible = true
    is_player_near = true

func on_body_exit(body):
    # print("exited interactable")
    Game.get_player().get_node("interact_sprite").visible = false
    on_dismiss()
    is_player_near = false
    is_interacting = false

func _process(_delta):
    if is_player_near and Input.is_action_just_pressed("grapple"):
        interact()
        
func interact():
    emit_signal("interact")
    if not is_interacting:
        is_interacting = true
        # print("now interacting")
        await on_interact().completed
        # print("no longer interacting")
        is_interacting = false

func on_interact():
    yield()

func on_dismiss():
    pass
        
