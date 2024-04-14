extends Control

const spent_history_panel = preload("res://script/spentHistory_panel.tscn")

@onready var front = $Front
@onready var foreground = $Foreground
@onready var ground = $Ground
@onready var slide_animation = $Slide_Animation
@onready var spent_history_screen = $Foreground/ScrollContainer/VBoxContainer

@onready var INEamountSpent = $Front/PnewEntry/lneAmountSpent
@onready var INEtypeSpent = $Front/PnewEntry/lneType
@onready var current_money = $Ground/current_money
@onready var settings_panel = $Front/settings

var userDataFile = "user://userdata.json"
var settings_open = false

func data_saving(child_index):
	var save_data : FileAccess
	if FileAccess.file_exists(userDataFile):
		save_data = FileAccess.open(userDataFile, FileAccess.READ_WRITE)
	else :
		save_data = FileAccess.open(userDataFile, FileAccess.WRITE)
		
	var node_data = spent_history_screen.get_child(child_index).call("save")
	var json_string = JSON.stringify(node_data)
	save_data.seek_end()
	save_data.store_line(json_string)

func data_loading():
	for i in range(spent_history_screen.get_child_count()):
		spent_history_screen.get_child(i).queue_free()
	
	var user_data = FileAccess.open(userDataFile, FileAccess.READ)
	while user_data.get_position() < user_data.get_length():
		var json_string = user_data.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		var new_entry = spent_history_panel.instantiate()
		AddingNewEntry(new_entry, int(node_data["amount_spent"]), node_data["amount_type"])
		current_money.text = node_data["current_money"]

# Called when the node enters the scene tree for the first time.
func _ready():
	slide_animation.play("first_enter")
	if not FileAccess.file_exists(userDataFile):
		settings_panel.visible = true
		$Front/settings/first_login.visible = true
		$Front/settings/change_money.visible = false
		first_start_load()
	else :
		data_loading()

func first_start_load():
	pass


func _on_btn_new_entry_pressed():
	if front.size.y == 284:
		slide_animation.play("new_entry_open")
	elif front.size.y == 1244:
		slide_animation.play("new_entry_close")
		

func _on_btn_add_new_entry_pressed():
	var new_entry = spent_history_panel.instantiate()
	AddingNewEntry(new_entry, int(INEamountSpent.text), INEtypeSpent.text)
	data_saving(new_entry.get_index())
	INEamountSpent.clear()
	INEtypeSpent.clear()
func AddingNewEntry(entry, amountspent, amounttype):
	current_money.text = set_money(int(current_money.text) - amountspent)
	entry.set_value(set_money(amountspent), amounttype, current_money.text)
	slide_animation.play("entry_placed_close")
	spent_history_screen.add_child(entry)
	spent_history_screen.move_child.call_deferred(entry, 0)
	

func _on_btnfirstloginconfirm_pressed():
	current_money.text = set_money(int($Front/settings/first_login/lnefirstloginmoney.text)) 
	slide_animation.play("first_login_close")
	$Front/settings/first_login.queue_free()
	
func set_money(money):
	var text = ""
	while money >= 1000:
			text += ",%03d" % (int(money) % 1000)
			money /= 1000
	return str(money) + text

func _on_settings_pressed():
	if settings_panel.visible == false:
		slide_animation.play("open_settings")
	elif settings_panel.visible == true:
		slide_animation.play("close_settings")

func _on_btnchangemoney_pressed():
	current_money.text = set_money(int($Front/settings/change_money/lnechangemoney.text)) 
	slide_animation.play("close_settings")
