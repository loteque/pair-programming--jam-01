extends CharacterBody2D

@export var speed := 50
@export var projectile_pool: ObjectPool
@export var attack_interval := 30
@export var projectile_speed := 100

var is_invincible = false
@onready var iframe_timer = $IFrameTimer 
@onready var sprite = $Sprite2D
@onready var sprite_fx_animations = sprite.get_node("FXAnimationPlayer")
@onready var projectile_start = $ProjectileStart
@onready var projectile_target = $ProjectileTarget
@onready var health_component: HealthComponent = $HealthComponent


func _ready():
	$Sprite2D.self_modulate = Color(1, 1, 1)

func _physics_process(_delta):
	
	if is_attack_frame():
		attack()
	
	var motion = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		motion.y -= 1

	if Input.is_action_pressed("ui_down"):
		motion.y += 1
		
	if Input.is_action_pressed("ui_left"):
		motion.x -= 1
		face_left()

	if Input.is_action_pressed("ui_right"):
		motion.x += 1
		face_right()

	if motion.x == 0 and motion.y == 0:
		sprite.play("idle")

	else:
		sprite.play("run")

	motion = motion.normalized() * speed
	set_velocity(motion)
	move_and_slide()

func is_attack_frame():
	return Engine.get_physics_frames() % attack_interval == 0

func face_left():
	global_transform.x.x = -1

func is_facing_left():
	return global_transform.x.x == -1

func face_right():
	global_transform.x.x = 1

func _on_HurtBox_body_entered(body):
	if body.is_in_group("CanHurtPlayer") and !is_invincible:
		take_damage(body.damage)
		make_temporarily_invincible()

func take_damage(amount):
	Signals.emit_signal("player_hit")
	sprite_fx_animations.play("Hit Flash")
	health_component.damage(amount)

func make_temporarily_invincible():
	is_invincible = true
	start_iframe_timer()

func start_iframe_timer():
	iframe_timer.start()
	
func _on_IFrameTimer_timeout():
	make_vincible()

func make_vincible():
	is_invincible = false

func rotate_180(radians: float):
	return radians + PI

func attack():
	var bullet = projectile_pool.get_object()
	bullet.visible = true
	var facing_angle = projectile_start.get_angle_to(projectile_target.global_position)
	if is_facing_left():
		facing_angle = rotate_180(facing_angle)
	
	bullet.update(projectile_speed, facing_angle)
	bullet.global_position = projectile_start.global_position
#	get_tree().root.add_child(bullet)
	Signals.emit_signal("projectile_shot")
