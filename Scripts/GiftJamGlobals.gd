extends Node

enum NoteType { UP, DOWN, RIGHT, LEFT }
enum NoteHitStatus { NONE, MISS, OK, GREAT, PERFECT}
var GIFJAM_BPM : int = 60
var GIFJAM_BPM_IN_SECONDS = 60.0 / 60.0 

signal BPM_Notification()
signal Fight_Start()

signal Note_Hit_Result(result : NoteHitStatus) 
