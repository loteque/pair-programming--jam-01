extends Node
class_name HealthComponent

@export var MAX_HEALTH: float: set = set_max_health
@export var MIN_HEALTH := 0.0

@onready var health := MAX_HEALTH: get = get_health, set = set_health

signal died

func _ready():
	set_health(MAX_HEALTH)
	set_max_health(MAX_HEALTH)

func set_max_health(value):
	if value > MIN_HEALTH:
		MAX_HEALTH = value
	Signals.player_max_health_changed.emit(value)

func get_max_health():
	return MAX_HEALTH

func set_health(value):
	health = clamp(value, MIN_HEALTH, MAX_HEALTH)
	Signals.player_health_changed.emit(health)

func get_health():
	return health
	
func heal(value):
	set_health(health + value)

func damage(value):
	set_health(health - value)
	if health <= 0:
		die()
	print("Took damage: " + str(value) + ": " + str(health))
	
func die():
	emit_signal("died")
