extends PathFollow2D
class_name NoteHitter

var NoteInsideHitter : Note = null
#FLAGS TO KNOW WHERE IS THE NOTE INSIDE THE HITTER
var OK : bool = false
var GREAT : bool = false
var PERFECT : bool = false

var playerCanHitNotes : bool = false

func SetBPM(SONG_BPM:float):
	var placeToHitTween :Tween = self.create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN);
	placeToHitTween.tween_property($PlaceToHit, "scale", Vector2(0.1,0.1), (60.0/SONG_BPM)/2.0)
	placeToHitTween.tween_property($PlaceToHit, "scale", Vector2(0.2,0.2), (60.0/SONG_BPM)/2.0)
	placeToHitTween.set_loops()
	
func _process(_delta):
	if Input.is_action_just_pressed("input_right"):
		TryHitNote(GiftJamGlobals.NoteType.RIGHT)
	if Input.is_action_just_pressed("input_left"):
		TryHitNote(GiftJamGlobals.NoteType.LEFT)
	if Input.is_action_just_pressed("input_up"):
		TryHitNote(GiftJamGlobals.NoteType.UP)
	if Input.is_action_just_pressed("input_down"):
		TryHitNote(GiftJamGlobals.NoteType.DOWN)

func TryHitNote(dir : GiftJamGlobals.NoteType):
	#Avoid hitting the note more than once 
	if playerCanHitNotes and NoteInsideHitter and not NoteInsideHitter.GetNoteWasHit():
		var noteHitStatus : GiftJamGlobals.NoteHitStatus = GiftJamGlobals.NoteHitStatus.MISS
		if PERFECT:
			noteHitStatus = GiftJamGlobals.NoteHitStatus.PERFECT
		elif GREAT:
			noteHitStatus = GiftJamGlobals.NoteHitStatus.GREAT
		elif OK:
			noteHitStatus = GiftJamGlobals.NoteHitStatus.OK
		
		var hitResult : GiftJamGlobals.NoteHitStatus = NoteInsideHitter.NoteHit(dir, noteHitStatus)
		GiftJamGlobals.Note_Hit_Result.emit(hitResult, dir)

func SetShowingNotesToPlayer(pCanHit:bool):
	playerCanHitNotes = pCanHit
	

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
	if playerCanHitNotes and note.is_in_group("note"):
		if NoteInsideHitter and not NoteInsideHitter.GetNoteWasHit():
			var result : GiftJamGlobals.NoteHitStatus = NoteInsideHitter.NoteHit(GiftJamGlobals.NoteType.UP,GiftJamGlobals.NoteHitStatus.MISS) #Dir does not matter, its a miss
			GiftJamGlobals.Note_Hit_Result.emit(result,GiftJamGlobals.NoteType.UP)
		NoteInsideHitter = null
		OK = false
