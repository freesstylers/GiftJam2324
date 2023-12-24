extends Path2D

@export var NumBeats : float = 5
@export var verticalLine : PackedScene = null
@export var keyNote : PackedScene = null
@export var NotesFadeAwayLength : float = 1.0

@export var Beginning : Node2D= null
@export var End  : Node2D= null

var bpm_movement : float = (60.0 / GiftJamGlobals.GIFJAM_BPM) / NumBeats
var bpm_lines = []
var notes_in_rails = []

var placeToHit : NoteHitter = null
var placeToHitTween : Tween = null

func _ready():
	placeToHit = $NoteHitter
	placeToHit.progress_ratio = (NumBeats-1)  / NumBeats
	bpm_movement = (GiftJamGlobals.GIFJAM_BPM / 60.0) / NumBeats
	for i in range(NumBeats):
		var newLine = verticalLine.instantiate() as PathFollow2D
		var pathFollow = (newLine as PathFollow2D)
		self.add_child(newLine)
		var progress : float = 1.0 - (1.0 * i / NumBeats)
		pathFollow.progress_ratio = progress
		bpm_lines.append(pathFollow)
	AddKeyNote()
	
func _process(delta):
	for i in range(bpm_lines.size()):
		var current_element : PathFollow2D = bpm_lines[i]
		current_element.progress_ratio += (bpm_movement * delta)
	for i in range(notes_in_rails.size()):
		var current_element : Note = notes_in_rails[notes_in_rails.size()-i-1]
		var deltaMovement = (bpm_movement * delta)
		if current_element.progress_ratio + deltaMovement > 1.0:
			current_element.progress_ratio = 1.0
			var deltaPos = (End.global_position-Beginning.global_position).normalized() * 100
			current_element.FadeAway(NotesFadeAwayLength, End.global_position + deltaPos)
			notes_in_rails.remove_at(i)
		else:
			current_element.progress_ratio += deltaMovement		
		
func AddKeyNote():
	var newNote = keyNote.instantiate() as Note
	var pathFollow = (newNote as PathFollow2D)
	self.add_child(newNote)
	pathFollow.progress_ratio = 0.0
	notes_in_rails.append(pathFollow)
