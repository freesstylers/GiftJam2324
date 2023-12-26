extends PathFollow2D
class_name NoteHitter

var placeToHitTween : Tween = null
var notes_available = []
var myKeyType : GiftJamGlobals 
var NoteInsideHitter : Note = null

var OK : bool = false
var GREAT : bool = false
var PERFECT : bool = false

var onAttackMode : bool = true

func _ready():
	placeToHitTween = self.create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN);
	placeToHitTween.tween_property($PlaceToHit2, "scale", Vector2(0.1,0.1), GiftJamGlobals.GIFJAM_BPM_IN_SECONDS/2)
	placeToHitTween.tween_property($PlaceToHit2, "scale", Vector2(0.2,0.2), GiftJamGlobals.GIFJAM_BPM_IN_SECONDS/2)
	placeToHitTween.set_loops()
	
func _process(_delta):
	if onAttackMode:
		if Input.is_action_just_pressed("input_right"):
			TryHitNote(GiftJamGlobals.NoteType.RIGHT)
		if Input.is_action_just_pressed("input_left"):
			TryHitNote(GiftJamGlobals.NoteType.LEFT)
		if Input.is_action_just_pressed("input_up"):
			TryHitNote(GiftJamGlobals.NoteType.UP)
		if Input.is_action_just_pressed("input_down"):
			TryHitNote(GiftJamGlobals.NoteType.DOWN)
	else:		
		if Input.is_action_just_pressed("input_right"):
			TryHitNote(GiftJamGlobals.NoteType.LEFT)
		if Input.is_action_just_pressed("input_left"):
			TryHitNote(GiftJamGlobals.NoteType.RIGHT)
		if Input.is_action_just_pressed("input_up"):
			TryHitNote(GiftJamGlobals.NoteType.DOWN)
		if Input.is_action_just_pressed("input_down"):
			TryHitNote(GiftJamGlobals.NoteType.UP)

func TryHitNote(dir : GiftJamGlobals.NoteType):
	#Avoid hitting the note more than once 
	if NoteInsideHitter and not NoteInsideHitter.GetNoteWasHit():
		var noteHitStatus : GiftJamGlobals.NoteHitStatus = GiftJamGlobals.NoteHitStatus.MISS
		if PERFECT:
			noteHitStatus = GiftJamGlobals.NoteHitStatus.PERFECT
		elif GREAT:
			noteHitStatus = GiftJamGlobals.NoteHitStatus.GREAT
		elif OK:
			noteHitStatus = GiftJamGlobals.NoteHitStatus.OK
		
		var hitResult : GiftJamGlobals.NoteHitStatus = NoteInsideHitter.NoteHit(dir, noteHitStatus)
		GiftJamGlobals.Note_Hit_Result.emit(hitResult)

func SetAttackMode(attackMode:bool):
	onAttackMode = attackMode

#Callbacks handling Notes entering each of the areas
func note_enter_ok_area(note):
	if note.is_in_group("note"):
		NoteInsideHitter = note as Note
		OK = true
func note_enter_great_area(note):
	if note.is_in_group("note"):
		GREAT = true
func note_enter_perfect_area(note):
	if note.is_in_group("note"):
		PERFECT = true
func note_exit_perfect_area(note):
	if note.is_in_group("note"):
		PERFECT = false
func note_exit_great_area(note):
	if note.is_in_group("note"):
		GREAT = false
func note_exit_ok_area(note):
	#Here I get the area2D attached to the Note, but the catch is that it is actually the area2d's father who has
	#the Note script and controls its hehaviour
	if note.is_in_group("note"):
		if not NoteInsideHitter.GetNoteWasHit():
			var result : GiftJamGlobals.NoteHitStatus = NoteInsideHitter.NoteHit(GiftJamGlobals.NoteType.UP,GiftJamGlobals.NoteHitStatus.MISS) #Dir does not matter, its a miss
			GiftJamGlobals.Note_Hit_Result.emit(result)
		NoteInsideHitter = null
		OK = false
