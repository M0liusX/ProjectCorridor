extends Node


# State
var map = [
	['#','#','#','#'],
	['#','.','.','#'],
	['#','#','#','#'],
]
var pos  = Vector2(1,1)
var dir  = Vector2.UP

# Components
onready var View = $View


func _ready():
	self._update_view()


func _update_view():
	# Center
	match map[pos.y + dir.y][pos.x + dir.x]:
		'#': View.get_node("Center").set_texture(TileDictionaries.WALL)
		'.': pass
	# Left
	var left = Vector2(dir.y, -dir.x)
	match map[pos.y + left.y][pos.x + left.x]:
		'#': 
			View.get_node("Left").set_texture(TileDictionaries.WALL_ADJ)
			View.get_node("Left").set_position(Vector2(0, 0))
		'.': 
			View.get_node("Left").set_texture(TileDictionaries.WALL)
			View.get_node("Left").set_position(Vector2(-240, 0))
	# Right
	var right = Vector2(-dir.y, dir.x)
	match map[pos.y + right.y][pos.x + right.x]:
		'#': 
			View.get_node("Right").set_texture(TileDictionaries.WALL_ADJ)
			View.get_node("Right").set_position(Vector2(0, 0))
		'.': 
			View.get_node("Right").set_texture(TileDictionaries.WALL)
			View.get_node("Right").set_position(Vector2(240, 0))

func _input(event):
	if event.is_echo(): return
	if event.is_action_pressed("ui_left"):
		dir = Vector2(dir.y, -dir.x)
		print(pos)
	if event.is_action_pressed("ui_right"):
		dir = Vector2(-dir.y, dir.x)
		print(pos)
	if event.is_action_pressed("ui_up"):
		if (map[pos.y + dir.y][pos.x + dir.x] == '.'):
			pos += dir
			print(pos)
	self._update_view()
