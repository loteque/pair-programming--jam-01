class_name KeyValueComponent
extends Control

@export var resource: Resource
@export var key: Label
@export var value: Label

## Sets the text element of the value label given a resource (res) and var member name (res_key) of the resource.
func set_value_text(res: Resource, res_key: String):
	if res and res.has_method("get_value"):
		value.text = str(res.get_value(res_key))
