extends Path2D
class_name NoteRails

@export var NumBeats : float = 5
@export var verticalLine : PackedScene = null
@export var keyNote : PackedScene = null

var bpm_movement : float = (60.0 / GiftJamGlobals.GIFJAM_BPM) / NumBeats
var bpm_lines = []
var waiting_notes = []

var noteHitter : NoteHitter = null

func _ready():
	noteHitter = $NoteHitter
	noteHitter.progress_ratio = (NumBeats-1) / NumBeats

	bpm_movement = (GiftJamGlobals.GIFJAM_BPM / 60.0) / NumBeats
	#Place the vertical bars over the path2d so that they represent the beats
	for i in range(NumBeats):
		var newLine = verticalLine.instantiate() as PathFollow2D
		var pathFollow = (newLine as PathFollow2D)
		self.add_child(newLine)
		var progress : float = 1.0 - (1.0 * i / NumBeats)
		pathFollow.progress_ratio = progress
		bpm_lines.append(pathFollow)
		
	GiftJamGlobals.connect("BPM_Notification", Testing_AddNoteToBeat)
	
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
			print(waiting_notes[i].delay)
		if waiting_notes[0].delay <= 0:
			var spawning_note = waiting_notes[0]
			waiting_notes.remove_at(0)
			var newNote = (keyNote.instantiate() as Note)
			newNote.SetNoteType(spawning_note.noteType,noteHitter.progress_ratio, GiftJamGlobals.GIFJAM_BPM_IN_SECONDS)
			return newNote
	return null

########TESTING... TO DELETE#######
var everyN = 5
var auxN = 5	
func Testing_AddNoteToBeat():
	auxN = auxN -1
	if auxN <= 0:
		auxN = everyN
		AddKeyNote(0, randi() % 4)
########TESTING... TO DELETE#######
