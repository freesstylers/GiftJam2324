extends PathFollow2D
class_name NoteHitter

var placeToHitTween : Tween = null
var notes_available = []

func _ready():
	AnimatePlaceToHit()

func AnimatePlaceToHit():
	placeToHitTween = self.create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN);
	placeToHitTween.tween_property($PlaceToHit2, "scale", Vector2(0.1,0.1), GiftJamGlobals.GIFJAM_BPM_IN_SECONDS/2)
	placeToHitTween.tween_property($PlaceToHit2, "scale", Vector2(0.2,0.2), GiftJamGlobals.GIFJAM_BPM_IN_SECONDS/2)
	placeToHitTween.set_loops()

func note_enter_ok_area(note):
	if note.is_in_group("note"):
		print("OK ENTER")

func note_enter_great_area(note):
	if note.is_in_group("note"):
		print("GREAT ENTER")

func note_enter_perfect_area(note):
	if note.is_in_group("note"):
		print("PERFECT ENTER")	

func note_exit_perfect_area(note):
	if note.is_in_group("note"):
		print("PERFECT EXIT")	

func note_exit_great_area(note):
	if note.is_in_group("note"):
		print("GREAT EXIT")	

func note_exit_ok_area(note):
	if note.is_in_group("note"):
		print("OK EXIT")	
