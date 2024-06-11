@tool
extends Control

var file4 = FileAccess.open("res://addons/simplenote/savelog.txt",FileAccess.READ)
var current_dir = file4.get_line()

# Called when the node enters the scene tree for the first time.
func _ready():
	var file3 = FileAccess.open("res://addons/simplenote/savelog.txt",FileAccess.READ)
	load_file(file3.get_line())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save(path, ctni : bool = true):
	var save
	if ctni:
		save = {"title" : $Control/LineEdit.text,"note" : $Control/PanelContainer/MarginContainer/TextEdit.text}
	elif !ctni:
		save = {"title" : "","note" : ""}
	var json = JSON.stringify(save)
	var file = FileAccess.open(path,FileAccess.WRITE)
	if file != null:
		file.store_string(json) 
	else:
		print_debug("can't open the path")
	file.close()
	#var filee = FileAccess.open("res://addons/simplenote/savelog.txt",FileAccess.WRITE)
	#if filee != null:
		#filee.store_line(path) 
	#else:
		#print_debug("can't open the savelog")
	#filee.close()
	
func load_file(path):
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


func _on_button_pressed():
	save(current_dir)
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
