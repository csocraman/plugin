@tool
extends EditorPlugin

var eposd = 1
var note = preload("res://addons/simplenote/note.tscn")
var noteins
var noteinsdock
var noteinsbottompanel
var eposbp = 1


func _enter_tree():
	noteins = note.instantiate()
	noteinsdock = note.instantiate()
	noteinsbottompanel = note.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(noteins)
	_make_visible(false)
	
func _get_plugin_icon():
	return preload("res://addons/simplenote/Frame 1icon.svg")

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
	if eposd == 2:
		remove_control_from_docks(noteinsdock)
	if eposbp == 2:
		removebottompanel()
	
func _process(delta):
	if noteins.eposition == 1 and eposd == 2:
		removeofthedocks()
		eposd = 1
	elif noteins.eposition == 2 and eposd == 1:
		eposd = 2
		todocks()
	if noteins.epositionbp == 1 and eposbp == 2:
		removebottompanel()
		eposbp = 1
	elif noteins.epositionbp == 2 and eposbp == 1:
		bottompanel()
		eposbp = 2

func todocks():
	noteinsdock.get_child(0).get_child(0).get_child(6).get_popup().set_item_disabled(11,true)
	noteinsdock.get_child(0).get_child(0).get_child(6).get_popup().set_item_disabled(12,true)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL,noteinsdock)
	
func removeofthedocks():
	remove_control_from_docks(noteinsdock)

func bottompanel():
	noteinsbottompanel.get_child(0).get_child(0).get_child(6).get_popup().set_item_disabled(11,true)
	noteinsbottompanel.get_child(0).get_child(0).get_child(6).get_popup().set_item_disabled(12,true)
	add_control_to_bottom_panel(noteinsbottompanel,"Simplenote")

func removebottompanel():
	remove_control_from_bottom_panel(noteinsbottompanel)
