## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Search siblings (parent's children) all the way (recursive), find ones with matching conditions.
## Attach given component nodes to found targets.
## NOTE: The [_attach_count] can be used for loading screen progress.
class_name Builder
extends Node

@export_group("Conditions")
## keys are node properties and values are needed target values (leave null for any value).
@export var condition_properties: Dictionary
## keys are node properties and values are forbidden target values (leave null for any value).
@export var not_condition_properties: Dictionary

@export_group("Components")
@export var attach_components: Array[PackedScene]
## if key matches the node name, value should be a dictionary of form:
## {TYPE: PROPERTIES} where PROPERTIES is a dictionary of custom values for component instance.
@export var customize: Dictionary
## if key matches the node name, will skip value as a list of attach_components.
@export var skip: Dictionary

var _condition_class: Variant
var _no_condition_classes: Array[Variant]
var _no_condition_names: Array[String]

var _attach_count: int = 0


func _ready() -> void:
	initialize()


func initialize(
	condition_class: Variant = Node,
	no_condition_classes: Array[Variant] = [],
	no_condition_names: Array[String] = []
) -> void:
	_condition_class = condition_class
	_no_condition_classes = no_condition_classes
	_no_condition_names = no_condition_names
	search_children(self.get_parent())

	#LogWrapper.debug(
		#name,
		#"Attached %d instances of %d components each." % [_attach_count, attach_components.size()]
	#)


func search_children(node: Node) -> void:
	for child: Node in node.get_children(true):
		search_children(child)
		if is_matching_conditions(child):
			do_attach_components(child)


func is_matching_conditions(node: Node) -> bool:
	var matching_condition_classes: bool = is_matching_condition_classes(node)
	if not matching_condition_classes:
		return false

	var matching_condition_properties: bool = is_matching_condition_properties(node)
	if not matching_condition_properties:
		return false

	return true


func is_matching_condition_classes(node: Node) -> bool:
	if not is_instance_of(node, _condition_class):
		return false

	for no_condition_class: Variant in _no_condition_classes:
		if is_instance_of(node, no_condition_class):
			return false

	for no_condition_name: Variant in _no_condition_names:
		if node.name == no_condition_name:
			return false

	return true


func is_matching_condition_properties(node: Node) -> bool:
	for condition_property: String in condition_properties:
		if condition_property not in node:
			return false
		var value: Variant = condition_properties[condition_property]
		if value != null and value != node.get(condition_property):
			return false

	for not_condition_property: String in not_condition_properties:
		if not_condition_property not in node:
			return false
		var value: Variant = not_condition_properties[not_condition_property]
		if value != null and value == node.get(not_condition_property):
			return false

	return true


func do_attach_components(parent: Node) -> void:
	_attach_count += 1

	for component: PackedScene in attach_components:
		var instance: Node = component.instantiate()
		if is_skip(instance, parent):
			continue

		customize_component(instance, parent)
		NodeUtils.add_child_back(instance, parent)


func is_skip(node: Node, parent: Node) -> bool:
	for skip_name: String in skip:
		if parent.name != skip_name:
			continue

		var skip_type: Variant = skip[skip_name]
		if is_instance_of(node, skip_type):
			return true

	return false


func customize_component(node: Node, parent: Node) -> void:
	for custom_name: String in customize:
		if parent.name != custom_name:
			continue

		var custom: Dictionary = customize[custom_name]
		for type: Variant in custom:
			if is_instance_of(node, type):
				var properties: Dictionary = custom[type]
				for property: String in properties:
					if property in node:
						node.set(property, properties[property])
