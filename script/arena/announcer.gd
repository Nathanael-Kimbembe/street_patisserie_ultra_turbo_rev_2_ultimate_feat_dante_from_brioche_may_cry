extends Control

var STATE = 0
var ROUND = 0

var announcement_label : Label
var announcement_timer : Timer
var announcement_tween : Tween

func _ready():
	announcement_label = $Label
	announcement_timer = $Timer
	announcement_tween = get_tree().create_tween()

	announcement_timer.connect("timeout", _on_announcement_timeout, 0)

	# Start the announcement sequence
	start_announcement_sequence()

func start_announcement_sequence():
	display_announcement("The bakery is burning", 2, first_announcement())

func display_announcement(text, duration, animation):
	init_announcement()
	announcement_label.text = text

	if (animation != null):
		call(animation)
	announcement_timer.wait_time = duration
	announcement_timer.start()

func first_announcement():
	var m = announcement_label.modulate
	var target_vanish = Color(m.r, m.g, m.b, 0)
	var target_scale = Vector2(1.5, 1.5)
	announcement_label.set_rotation_degrees(0)
	var tween = get_tree().create_tween()

	tween.tween_property(announcement_label, "scale", target_scale, 0.4)
	tween.tween_property(announcement_label, "rotation_degrees", 360, 0.4).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(announcement_label, "modulate", target_vanish, 0.3).set_delay(0.6).set_ease(Tween.EASE_IN_OUT)

func second_announcement():
	var m = announcement_label.modulate
	var target_vanish = Color(m.r, m.g, m.b, 0)
	var target_scale = Vector2(1.5, 1.5)
	announcement_label.set_rotation_degrees(0)
	var tween = get_tree().create_tween()

	var curpos = announcement_label.get_position()
	announcement_label.set_position(Vector2(curpos.x * 1.1, curpos.y))

	tween.tween_property(announcement_label, "scale", target_scale, 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(announcement_label, "modulate", target_vanish, 0.3).set_delay(0.6).set_ease(Tween.EASE_IN_OUT)

func third_announcement():
	var m = announcement_label.modulate
	var target_vanish = Color(m.r, m.g, m.b, 0)
	var target_scale = Vector2(1.5, 1.5)
	var wide = Vector2(2.5, 1.5)
	announcement_label.set_rotation_degrees(0)
	var tween = get_tree().create_tween()

	tween.tween_property(announcement_label, "scale", wide, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(announcement_label, "scale", target_scale, 0.4).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(announcement_label, "modulate", target_vanish, 0.3).set_delay(0.6).set_ease(Tween.EASE_IN_OUT)

func _on_announcement_timeout():
	announcement_label.text = ""
	STATE += 1
	if (STATE == 1):
		display_announcement("BATCH 1", 2, second_announcement())
	elif (STATE == 2):
		display_announcement("LETS COOK!", 2, third_announcement())
	pass

func init_announcement():
	announcement_label.text = ""
	announcement_label.modulate.a = 1
	announcement_label.scale = Vector2(0.1, 0.1)
	announcement_label.set_rotation_degrees(0)