extends Node2D
func _ready():
	controller()
	$"1".focus_neighbour_right = $"2".get_path()
	$"2".focus_neighbour_left = $"1".get_path()
	$"2".focus_neighbour_right = $"3".get_path()
	$"3".focus_neighbour_left = $"2".get_path()
func level1():
	get_tree().change_scene("res://level1.tscn")
func level2():
	get_tree().change_scene("res://level2.tscn")
func level3():
	get_tree().change_scene("res://level3.tscn")
func controller():
	var button_to_focus = get_node("1")
	if button_to_focus:
		button_to_focus.grab_focus()
