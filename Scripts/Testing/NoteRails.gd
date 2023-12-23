extends Node

@export var NumBeats : float = 5
@export var verticalLine : PackedScene = null
var path : Path2D = null

var bpm_movement : float = (60.0 / GiftJamGlobals.GIFJAM_BPM) / NumBeats
var bpm_lines = []

func _ready():
	bpm_movement = (GiftJamGlobals.GIFJAM_BPM / 60.0) / NumBeats
	path = $KeysPath
	for i in range(NumBeats):
		var newLine = verticalLine.instantiate() as PathFollow2D
		var pathFollow = (newLine as PathFollow2D)
		path.add_child(newLine)
		var progress : float = 1.0 - (1.0 * i / NumBeats)
		pathFollow.progress_ratio = progress
		bpm_lines.append(pathFollow)

func _process(delta):
	for i in range(bpm_lines.size()):
		var current_element : PathFollow2D = bpm_lines[i]
		current_element.progress_ratio += (bpm_movement * delta)
