@tool
extends Control

var current_dir = ""
var hf = false

@onready var view = $Control/HBoxContainer/MenuButton

@export var eposition : int = 1
@export var epositionbp : int = 1

var focus_nodes : PackedStringArray = ["Control/LineEdit","Control/PanelContainer/MarginContainer/TextEdit"]
var buttons : PackedStringArray = ["Control/HBoxContainer/Button","Control/HBoxContainer/Button2","Control/HBoxContainer/Button3"]

# Called when the node enters the scene tree for the first time.
func _ready():
	if "( )" in $Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.color_regions:
		view.get_popup().set_item_checked(1,true)
	if "' '" in $Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.color_regions or "\" \"" in $Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.color_regions:
		view.get_popup().set_item_checked(2,true)
	if "[ ]" in $Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.color_regions:
		view.get_popup().set_item_checked(3,true)
	if "{ }" in $Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.color_regions:
		view.get_popup().set_item_checked(4,true)
	if $Control/PanelContainer/MarginContainer/TextEdit.draw_tabs == true:
		view.get_popup().set_item_checked(6,true)
	if $Control/PanelContainer/MarginContainer/TextEdit.draw_spaces == true:
		view.get_popup().set_item_checked(7,true)
	if $Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.number_color != Color8(164,164,166):
		view.get_popup().set_item_checked(9,true)
	var file3 = FileAccess.open("res://addons/simplenote/log.txt",FileAccess.READ)
	load_file(file3.get_line(),false)
	view.get_popup().id_pressed.connect(viewf) 	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SAVED.position.x = $".".size.x - 20
	for a in focus_nodes:
		if get_node(a).has_focus():
			for b in buttons:
				get_node(b).set_process_shortcut_input(true)
			hf = true
			break
		else:
			hf = false
				
	if hf == false:
		for b in buttons:
			get_node(b).set_process_shortcut_input(false)
func save(path, ctni : bool = true):
	if FileAccess.file_exists(path) or path != "":
		var save
		if ctni:
			save = {"title" : $Control/LineEdit.text,"note" : $Control/PanelContainer/MarginContainer/TextEdit.text}
		elif !ctni:
			save = {"title" : "","note" : ""}
		var json = JSON.stringify(save)
		var file = FileAccess.open(path,FileAccess.WRITE)
		file.store_line(json)
		file.close()
	else:
		$Control/HBoxContainer/Button2/FileDialog.visible = true	
	
func load_file(path, ltl : bool = true):
	if !FileAccess.file_exists(path):
		return
	
	var data
	var file = FileAccess.open(path,FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var jsonl = file.get_line()
		var json = JSON.new()
		
		var parse = json.parse(jsonl)
		data = json.get_data()
	$Control/LineEdit.text = data["title"]
	$Control/PanelContainer/MarginContainer/TextEdit.text = data["note"]
	current_dir = path
	file.close()
	if ltl:
		var filelastdir = FileAccess.open("res://addons/simplenote/log.txt",FileAccess.WRITE)
		filelastdir.store_string(current_dir)

func _on_button_pressed():
	save(current_dir)
	if FileAccess.file_exists(current_dir):
		$SAVED.visible = false
		var notefier = PanelContainer.new()
		var text = Label.new()
		text.text = "saved!"
		text.add_theme_font_size_override("font_size",20)
		notefier.add_child(text)
		notefier.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		notefier.position.y = $".".size.y
			
		var tween = create_tween().set_ease(Tween.EASE_IN)
		tween.tween_property(notefier,"position",	Vector2(notefier.position.x,notefier.position.y - 200),0.5)
		add_child(notefier)
		await get_tree().create_timer(0.5).timeout
		notefier.queue_free()	
		


func _on_button_2_pressed():
	$Control/HBoxContainer/Button2/FileDialog.visible = true
	
	


func _on_file_dialog_file_selected(path):
	load_file(path)


func _on_button_3_pressed():
	$Control/HBoxContainer/Button3/FileDialog2.visible = true



func _on_file_dialog_2_file_selected(path):
	current_dir = path
	save(path,false)
	load_file(path)
	var filelastdir = FileAccess.open("res://addons/simplenote/log.txt",FileAccess.WRITE)
	filelastdir.store_string(current_dir)
	




func _on_line_edit_text_changed(new_text):
	$SAVED.visible = true


func _on_text_edit_text_changed():
	$SAVED.visible = true

func viewf(id):
	if id == 1:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(1)) - 1) * -1))
		if view.get_popup().is_item_checked(1):
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.add_color_region("(",")",Color8(188,255,0))
		else:
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.remove_color_region("(")
	if id == 2:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(2)) - 1) * -1))
		if view.get_popup().is_item_checked(2):
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.add_color_region("\"","\"",Color8(255,255,0))
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.add_color_region("'","'",Color8(255,255,0))
		else:
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.remove_color_region("\"")
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.remove_color_region("'")
	if id == 3:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(3)) - 1) * -1))
		if view.get_popup().is_item_checked(3):
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.add_color_region("{","}",Color8(0,175,255))
		else:
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.remove_color_region("{")
	if id == 4:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(4)) - 1) * -1))
		if view.get_popup().is_item_checked(4):
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.add_color_region("[","]",Color8(255,0,0))
		else:
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.remove_color_region("[")
	if id == 6:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(6)) - 1) * -1))
		if view.get_popup().is_item_checked(6):
			$Control/PanelContainer/MarginContainer/TextEdit.draw_tabs = true
		else:
			$Control/PanelContainer/MarginContainer/TextEdit.draw_tabs = false
	if id == 7:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(7)) - 1) * -1))
		if view.get_popup().is_item_checked(7):
			$Control/PanelContainer/MarginContainer/TextEdit.draw_spaces = true
		else:
			$Control/PanelContainer/MarginContainer/TextEdit.draw_spaces = false
	if id == 9:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(9)) - 1) * -1))
		if view.get_popup().is_item_checked(9):
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.number_color = Color8(255,125,0)
		else:
			$Control/PanelContainer/MarginContainer/TextEdit.syntax_highlighter.number_color = Color8(164,164,166)
	if id == 11:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(11) ) - 1) * -1))
		eposition = int(view.get_popup().is_item_checked(11)) + 1
	if id == 12:
		view.get_popup().set_item_checked(id,bool((int(view.get_popup().is_item_checked(12) ) - 1) * -1))
		epositionbp = int(view.get_popup().is_item_checked(12)) + 1
