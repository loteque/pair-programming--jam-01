extends CharacterBody2D

@export var speed = 20
@export var MIN_CHASE_DISTANCE_PIXELS = 1
@export var death_health_value := 0
@export var item_dropped: PackedScene = preload("res://src/pickups/BottleCap.tscn")
var damage := 1
var health := 2

@onready var target = get_tree().get_nodes_in_group("player")[0]
@onready var sprite = $MobAnimatedSprite
@onready var sprite_fx_animations = sprite.get_node("FXAnimationPlayer")
@onready var cap_parent = get_node("/root/Main")

func _ready():
	pass

func _init(target = target):
	self.target = target

func _physics_process(_delta):
	chase_target(target)

func chase_target(target: Node2D):
	var distance = target.global_position - global_position
	if distance.length() > MIN_CHASE_DISTANCE_PIXELS:
		var direction = distance.normalized()
		set_velocity(direction * speed)
		move_and_slide()

func drop_item():
	var bottlecap = item_dropped.instantiate()
	bottlecap.global_position = global_position
	cap_parent.add_child(bottlecap)

func die():
	drop_item()
	queue_free()

func take_damage(value: float):
	Signals.emit_signal("mob_hit")
	sprite_fx_animations.play("Hit Flash")
	health -= value
	if health <= death_health_value:
		die()

func _on_HurtBox_area_entered(area):
	if area.is_in_group("CanDamageMob"):
		take_damage(area.damage)
