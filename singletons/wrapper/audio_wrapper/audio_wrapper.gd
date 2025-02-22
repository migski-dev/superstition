## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Wraps Resonance (Audio Manager) plugin: [MusicManager] [SoundManager]
## - uses enums instead of string names
## - extends [play_music] with [unique] flag that tracks [already_played] music
## [br][br]
## TODO: Does not wrap all methods. Wrap other methods from original classes if and when needed.
extends Node

var already_played: Dictionary = {}


func play_music(music: AudioEnum.Music, crossfade: float = 0.0, unique: float = true) -> void:
	var music_name: String = AudioEnum.music_name(music)
	if unique:
		if already_played.get(music_name, false):
			return
		already_played[music_name] = true
	MusicManager.play(AudioEnum.MUSIC_BANK, music_name, crossfade)


func play_sfx(sfx: AudioEnum.Sfx) -> void:
	SoundManager.play(AudioEnum.SOUND_BANK, AudioEnum.sfx_name(sfx))


func get_instance_poly_sfx(sfx: AudioEnum.Sfx) -> Variant:
	return SoundManager.instance_poly(AudioEnum.SOUND_BANK, AudioEnum.sfx_name(sfx))


func play_instance(instance: Variant) -> void:
	instance.trigger()
	instance.release(true)
	
func stop_music() -> void:
	MusicManager.stop(0.0)
	
