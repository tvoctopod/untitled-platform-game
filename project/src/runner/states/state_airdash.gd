extends RunnerState
class_name AirdashState

var airdash_dir: Vector2 = Vector2.ZERO
var on_ground: bool = false

var particles = null

func can_start():

    var axis = input.get_axis()
    return round(axis.length()) != 0

func on_start(state_name):

    var axis = input.get_axis().round().normalized();
    airdash_dir = Vector2.ZERO

    # determine airdash direction
    if runner.airdashes_left == 0 or axis == Vector2.ZERO:
        sm.goto_airborne()
        return
    else:
        on_ground = (
            state_name is IdleState
            or state_name is DashState
            or state_name is RunningState
            or state_name is AttackState
        )

        runner.airdashes_left -= 1
        airdash_dir = Vector2(axis.x, axis.y).normalized();
        #Game.get_camera().screen_shake(1.0, 0.3)

        # if runner.is_on_floor():
        #     runner.position.y -= 2

    runner.emit_signal("airdash")


func on_update(delta):

    # jump out of dash
    air_jump_if_able(true)
    walljump_if_able()

    if not is_active():
        return

    if not runner.is_on_floor():
        on_ground = false

    if tick == 1:
        # delayed start of particles
        particles = Effects.play(Effects.Airdash, runner)
        particles.get_node("wave").direction = -airdash_dir
        if runner.facing == Direction.LEFT:
            particles.get_node("trail").material.set_shader_param("flip", true)
        else:
            particles.get_node("trail").material.set_shader_param("flip", false)

    if tick >= 0 and tick <= runner.AIRDASH_LENGTH:

        # middle of airdashing

        # update airdash speed
        var airdash_speed = max(runner.AIRDASH_SPEED, runner.velocity.length())
        var t = pow(tick / float(runner.AIRDASH_LENGTH), 2)
        runner.velocity = (airdash_dir * lerp(
            airdash_speed, runner.AIRDASH_SPEED_END, t
        ))

        snap_up_to_ground(delta)

    if tick > runner.AIRDASH_LENGTH or (not on_ground and runner.is_on_floor()):

        # end of airdashing

        if runner.is_on_floor():
            if is_instance_valid(particles):
                particles.emitting = false
            sm.goto_idle()
            # sm.goto_idle_or_dash()
        else:
            sm.goto_airborne()

    if not is_active() and is_instance_valid(particles):
        particles.emitting = false
