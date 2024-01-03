extends Node

const ATTACK_COLOR = Color.AQUA
const DEFEND_COLOR = Color.CRIMSON

enum NoteType { NONE, UP, DOWN, LEFT, RIGHT }
enum NoteHitStatus { NONE, MISS, OK, GREAT, PERFECT}

const NoteSprites = ["res://Assets/Sprites/Notas/Arriba.png",
					"res://Assets/Sprites/Notas/Abajo.png",
					"res://Assets/Sprites/Notas/Izquierda.png",
					"res://Assets/Sprites/Notas/Derecha.png"]

signal BPM_Notification()
signal FromPresentationToBattle()
signal FromBattleToMainMenu()
signal Fight_Start()
signal Note_Hit_Result(result : NoteHitStatus, dir : NoteType) 

enum characterHit {Ragnahilda, Enemy}
signal LifeChanged(who : characterHit, quantity : int)

