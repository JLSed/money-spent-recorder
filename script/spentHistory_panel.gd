extends Control

@onready var lbl_spent_amount = $Panel/lblspent_amount
@onready var lbl_type_amount = $Panel/lblspent_amount/lblspent_type
@onready var entrance_animation = $Entrance_Animation

var spent_amount:String
var spent_type:String
var current_money:String

#var data = user_data.new()

func _ready():
	lbl_spent_amount.text = "-" + str(spent_amount)
	lbl_type_amount.text = "• " + spent_type
	entrance_animation.play("entrance")

func set_value(spent, type, money):
	spent_amount = spent
	spent_type = type
	current_money = money
	
func get_spentAmount():
	return spent_amount
	
func get_spentType():
	return spent_type

func save():
	var details = {
			"amount_spent" : spent_amount,
			"amount_type" : spent_type,
			"current_money": current_money
	}
	return details
