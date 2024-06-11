@tool
extends EditorPlugin

var note = preload("note.tscn")
var noteins

func _enter_tree():
	noteins = note.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(noteins)
	_make_visible(false)
	
func _get_plugin_icon():
	return preload("Frame 1icon.svg")

func _get_plugin_name():
	return "simple note"

func _has_main_screen():
	return true

func _make_visible(visible):
	if is_instance_valid(noteins):
		noteins.visible = visible

func _exit_tree():
	if is_instance_valid(noteins):
		noteins.queue_free()
