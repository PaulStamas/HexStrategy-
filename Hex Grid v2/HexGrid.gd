extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var r = "red"
var b = "blue"
var o = "empty"
var hex_map = [[o, r, r, r, r, o], 
			   [b, b, b, r, r, r],
			   [r, b, r, b, b, r],
			   [b, b, b, r, r, r]]

var hex_object_map = []
var setup_completed = false

onready var stem_hex_refference = $Stem_Hex
onready var stem_hex = preload("res://Stem_Hex.tscn")
const GRID_OFFSET = Vector2(300, 200)
# Called when the node enters the scene tree for the first time.
func _ready():
	var hex_h = stem_hex_refference.get_node("AnimatedSprite").frames.get_frame("Red", 0).get_height()
	var hex_w = stem_hex_refference.get_node("AnimatedSprite").frames.get_frame("Red", 0).get_width()
	var hex_center = Vector2(hex_h/2, hex_w/2)
	var hex_temp_pos = Vector2(0,0)
	var hex_pos = hex_temp_pos
	var grid_gap = 0
	for q in hex_map.size():
		hex_pos.y = q
		var temp_row = []
		for r in hex_map[q].size():
			hex_pos.x = r
			var hex_global_pos = Vector2()
			
			if q % 2 != 0:
				hex_global_pos.x = (hex_pos.x * (hex_w + grid_gap) + GRID_OFFSET.x) + hex_w/2
			else:
				hex_global_pos.x = hex_pos.x * (hex_w + grid_gap)  + GRID_OFFSET.x
			hex_global_pos.y = hex_pos.y * (hex_h * 3/4 + grid_gap) + GRID_OFFSET.y
			var hex_type = hex_map[q][r]
			if hex_type != "empty":
				var hex = stem_hex.instance()
				hex.init(hex_type, Vector2(r, q))
				hex.position = hex_global_pos
				add_child(hex)
				temp_row.append(hex)
			else:
				temp_row.append("empty")
		hex_object_map.append(temp_row)
		
	for objects in hex_object_map:
		for hex in objects:
			if typeof(hex) == 17:
				hex.get_adjacent()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("LeftClick"):
		var mouse_pos = get_global_mouse_position()		
