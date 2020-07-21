extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum {RED, BLUE}
var type
var grid_pos
var adjacents = []
var red_hex = load("res://Hex_Red.gd").new()
onready var global = $"/root/Globals"

var mouse_touch = false

func init(hex_type, coords):
	if hex_type == "blue":
		type = BLUE
	elif hex_type == "red":
		type = RED
	
	grid_pos = coords
	
# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		RED:
			$AnimatedSprite.play("Red")
			red_hex.on_ready()
		BLUE:
			$AnimatedSprite.play("Blue")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match type:
		RED:
			red_hex.on_process()
		BLUE:
			pass
		
	if mouse_touch == true and Input.is_action_just_pressed("left_click"):
		for hex in adjacents:
			if typeof(hex) == TYPE_STRING:
				print(hex)
			else:
				print(hex.grid_pos)


func _on_Area2D_mouse_entered():
	$AnimatedSprite.frame = 1
	mouse_touch = true

func _on_Area2D_mouse_exited():
	$AnimatedSprite.frame = 0
	mouse_touch = false
	
func get_adjacent():
	var adjacent_coords = []
	var directions = [
	[[0,  -1], [+1,  0], [0,  +1], 
	 [-1,  1], [-1,  0], [-1, -1]],
	[[+1, -1], [+1,  0], [+1, +1], 
	 [0,  +1], [-1,  0], [0,  -1]],
	]
	
	var dir
	if int(grid_pos.y) % 2 == 0:
		dir = directions[0]
	else:
		dir = directions[1]
	for coord in dir:
		var temp_coord = Vector2()
		temp_coord.x = coord[0] + grid_pos.x
		temp_coord.y = coord[1] + grid_pos.y
		adjacent_coords.append(temp_coord)
	
	var object_map = get_parent().hex_object_map
	for coord in adjacent_coords:
		if (!coord[1] > object_map.size() - 1 and !coord[0] > object_map[1].size() -1) and (!coord[1] < 0 and !coord[0] < 0):
			adjacents.append(object_map[coord[1]][coord[0]])
