extends Node


# State
var map = [
	['#','#','#','#','#','#'],
	['#','.','.','#','#','#'],
	['#','#','.','.','.','#'],
	['#','.','.','#','.','#'],
	['#','#','#','#','#','#'],
]
var pos  = Vector2(1,1)
var dir  = Vector2.UP

# Components
onready var View = $View


func _ready():
	self._update_view()


func _update_view():
	self.deep_free(View)
	self._generate_view(self.pos, self.dir, View)


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		dir = Vector2(dir.y, -dir.x)
		self._update_view()
	elif Input.is_action_just_pressed("ui_right"):
		dir = Vector2(-dir.y, dir.x)
		self._update_view()
	elif Input.is_action_just_pressed("ui_up"):
		if (map[pos.y + dir.y][pos.x + dir.x] == '.'):
			pos += dir
			self._update_view()


func _generate_view(p, d, node):
	if node.z_index < -4: return
	# Center
	match read_map(p.x + d.x, p.y + d.y):
		'#': 
			var texture = Sprite.new()
			texture.set_texture(TileDictionaries.WALL)
			node.add_child(texture)
		'.': 
			var subnode = Node2D.new()
			subnode.z_index = node.z_index - 1
			subnode.scale = Vector2.ONE*0.6
			subnode.modulate = Color(0.75, 0.75, 0.75, 1.0)
			self._generate_view(p + d, d, subnode)
			node.add_child(subnode)
	# Left
	var left = Vector2(d.y, -d.x)
	match read_map(p.x + left.x, p.y + left.y):
		'#': 
			var texture = Sprite.new()
			texture.set_texture(TileDictionaries.WALL_ADJ)
			node.add_child(texture)
		'.': 
			if node.position != Vector2(240, 136) and node.position != Vector2.ZERO: return
			var subnode = Node2D.new()
			subnode.set_position(Vector2(-300,0))
			self._generate_view(p + left, d, subnode)
			node.add_child(subnode)
#			var texture = Sprite.new()
#			texture.set_texture(TileDictionaries.WALL)
#			texture.set_position(Vector2(-300, 0))
#			node.add_child(texture)
	# Right
	var right = Vector2(-d.y, d.x)
	match read_map(p.x + right.x, p.y + right.y):
		'#': 
			var texture = Sprite.new()
			texture.flip_h = true
			texture.set_texture(TileDictionaries.WALL_ADJ)
			node.add_child(texture)
		'.': 
			if node.position != Vector2(240, 136)and node.position != Vector2.ZERO: return
			var subnode = Node2D.new()
			subnode.set_position(Vector2(300,0))
			self._generate_view(p + right, d, subnode)
			node.add_child(subnode)
#			var texture = Sprite.new()
#			texture.set_texture(TileDictionaries.WALL)
#			texture.set_position(Vector2(300, 0))
#			node.add_child(texture)


func read_map(x, y):
	if y < map.size() and y >= 0:
		if x < map[0].size() and x >= 0:
			return map[y][x]
	return ' '


static func deep_free(node):
	for n in node.get_children():
		deep_free(n)
		n.queue_free()
		node.remove_child(n)
