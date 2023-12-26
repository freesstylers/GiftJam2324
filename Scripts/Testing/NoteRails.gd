extends Path2D
class_name NoteRails

@export var NumBeats : float = 5
@export var verticalLine : PackedScene = null
@export var keyNote : PackedScene = null

#BPM LINE RELATED
var bpm_lines = []
var bpm_movement : float = 0
#NOTES WAITING TO BE SPAWNED
var waiting_notes = []
#NOTE HITTER AND ATTACK MODE
var noteHitter : NoteHitter = null
var currentlyAttacking : bool = false
#CURRENT SONG BPM 
var currentSongBPM :float = 0
var currentSongSecondsPerBPM :float= 0

func _ready():
	noteHitter = $NoteHitter2
	noteHitter.progress_ratio = (NumBeats-1) / NumBeats
	#Place the vertical bars over the path2d so that they represent the beats
	for i in range(NumBeats):
		var newLine = verticalLine.instantiate() as PathFollow2D
		self.add_child(newLine)
		var progress : float = 1.0 - (1.0 * i / NumBeats)
		newLine.progress_ratio = progress
		bpm_lines.append(newLine)
	
func _process(delta):
	for i in range(bpm_lines.size()):
		var current_element : PathFollow2D = bpm_lines[i]
		var delta_movement = bpm_movement*delta
		#If the beat reached the path end, check for new notes to spawn
		if current_element.progress_ratio + delta_movement > 1.0:
			var noteToSpawn = GetPossibleNote()
			if noteToSpawn:
				current_element.add_child(noteToSpawn)
		current_element.progress_ratio += (bpm_movement * delta)
		
func AddKeyNote(delayInBeats: int ,noteType : GiftJamGlobals.NoteType):
	waiting_notes.append({delay = delayInBeats, noteType = noteType})
	
#Dictionary waiting_notes[i] = {delay : int, noteType : type: GiftJamGlobals.NoteType}
func GetPossibleNote()->Note:
	if waiting_notes.size() > 0:
		for i in range(waiting_notes.size()):
			waiting_notes[i].delay = waiting_notes[i].delay-1
		if waiting_notes[0].delay <= 0:
			var spawning_note = waiting_notes[0]
			waiting_notes.remove_at(0)
			var newNote = (keyNote.instantiate() as Note)
			newNote.SetNoteType(spawning_note.noteType,noteHitter.progress_ratio, currentSongSecondsPerBPM, currentlyAttacking)
			return newNote
	return null
	
func on_attack_mode_changed(mode):
	currentlyAttacking = mode
	noteHitter.SetAttackMode(mode)
	
func SetBPM(SONG_BPM:float):
	bpm_movement = (SONG_BPM / 60.0) / NumBeats
	currentSongBPM = SONG_BPM
	currentSongSecondsPerBPM = 60.0 / SONG_BPM
	noteHitter.SetBPM(SONG_BPM)
