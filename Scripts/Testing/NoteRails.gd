extends Path2D
class_name NoteRails

@export var NumBeats : float = 5
@export var verticalLine : PackedScene = null
@export var keyNote : PackedScene = null

#BPM LINE RELATED
var bpm_lines = []
var bpm_movement : float = 0
#NOTES WAITING TO BE SPAWNED
var waiting_set_of_notes = []
#NOTE HITTER AND ATTACK MODE
var noteHitter : NoteHitter = null
var currentlyAttacking : bool = false
#CURRENT SONG BPM 
var currentSongBPM :float = 0
var currentSongSecondsPerBPM :float= 0
var playerCanHitNotes : bool = true

var railsBackground : Panel = null
var railsActionpanel : Panel = null
var railsActionText : Label = null

func _ready():
	noteHitter = $NoteHitter2
	noteHitter.progress_ratio = 0
	
	railsBackground = $Background
	railsActionpanel = $Background/ActionPanel
	railsActionText = $Background/ActionPanel/ActionText
	railsActionpanel.position.y = 0
	
	#Place the vertical bars over the path2d so that they represent the beats
	for i in range(NumBeats+1):
		var newLine = verticalLine.instantiate() as PathFollow2D
		self.add_child(newLine)
		var progress : float =(1.0 * i / NumBeats)
		newLine.progress_ratio = progress
		bpm_lines.append(newLine)
	
func _process(delta):
	var delta_movement = bpm_movement*delta
	#If the beat reached the path end, check for new notes to spawn
	if noteHitter.progress_ratio + delta_movement > 1.0:
		#Player finished hitting notes, new set must be placed
		if playerCanHitNotes:
			playerCanHitNotes = false
			#Testing() # Create a new set of notes
			ClearCurrentSetOfNotes()
			PlaceNextSetOfNotes()
		#All the placed notes have faded in, now the player needs to hit them
		else:
			playerCanHitNotes = true
		noteHitter.SetShowingNotesToPlayer(playerCanHitNotes)
		UpdateVisuals()
	noteHitter.progress_ratio += (bpm_movement * delta)
	

func UpdateVisuals():
	#Subpanel con el texto de ATTACK/DEFEND
	var destY :int = -30
	var localTween : Tween = railsActionpanel.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if not playerCanHitNotes:
		destY = 0
		localTween.set_trans(Tween.TRANS_QUAD)
		localTween.set_ease(Tween.EASE_OUT)
	localTween.tween_property(railsActionpanel, "position:y", destY, 0.25)
	#Texto 
	if currentlyAttacking:
		railsActionText.text = "ATTACK"
	else:
		railsActionText.text = "DEFEND"
	#Tween del color del borde
	var myTween : Tween = railsBackground.create_tween()
	var destColor : Color = Color.MAGENTA
	if currentlyAttacking:
		destColor = GiftJamGlobals.ATTACK_COLOR
	else:
		destColor = GiftJamGlobals.DEFEND_COLOR
	myTween.tween_property(railsBackground, "theme_override_styles/panel:border_color", destColor, 0.3)

	
#Dictionary waiting_notes[i] = {delay : int, noteType : type: GiftJamGlobals.NoteType}
#nextSet = { notes : waiting_notes[i]}
func PlaceNextSetOfNotes():
	if waiting_set_of_notes.size() > 0:
		var nextSet = waiting_set_of_notes[0]
		waiting_set_of_notes.remove_at(0)
		for i in range(nextSet.notes.size()):
			var spawning_note_data = nextSet.notes[i]
			if spawning_note_data.noteType != GiftJamGlobals.NoteType.NONE:
				var newNote = (keyNote.instantiate() as Note)
				newNote.SetNoteType(spawning_note_data.noteType,noteHitter.progress_ratio, currentSongSecondsPerBPM, currentlyAttacking)
				bpm_lines[spawning_note_data.delay].add_child(newNote)
	
func ClearCurrentSetOfNotes():
	for i in range(bpm_lines.size()):
		for child in bpm_lines[i].get_children():
			var possibleNote : Note = null
			possibleNote = child as Note
			if possibleNote:
				bpm_lines[i].remove_child(child)
				child.queue_free()
	
func on_attack_mode_changed(mode):
	currentlyAttacking = mode
	
func SetBPM(SONG_BPM:float):
	bpm_movement = (SONG_BPM / 60.0) / NumBeats
	currentSongBPM = SONG_BPM
	currentSongSecondsPerBPM = 60.0 / SONG_BPM
	noteHitter.SetBPM(SONG_BPM)
	
func AddKeyNoteSet(newNotes):
	var testSetOfNotes = {}	
	testSetOfNotes.notes = []
	for i in range(NumBeats+1):
		testSetOfNotes.notes.append({delay = i, noteType=  newNotes[i]})
	waiting_set_of_notes.append(testSetOfNotes)

#Dictionary waiting_notes[i] = {delay : int, noteType : type: GiftJamGlobals.NoteType}
#nextSet = { notes : waiting_notes[i] }
func Testing():
	currentlyAttacking = not currentlyAttacking
	var testSetOfNotes = {}
	testSetOfNotes.notes = []
	testSetOfNotes.notes.append({delay = 1 + randi()%(NumBeats as int -1 ), noteType=  randi() % 4})
	testSetOfNotes.notes.append({delay = 1 + randi()%(NumBeats as int -1), noteType= randi() % 4})
	waiting_set_of_notes.append(testSetOfNotes)
