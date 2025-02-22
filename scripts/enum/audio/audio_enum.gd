## Original File MIT License Copyright (c) 2024 TinyTakinTeller
## [br][br]
## Corresponds to available audio in [ConfigurationAudio]'s music bank and sound bank nodes.
## [br][br]
## NOTE: Consider splitting into multiple classes if needed, e.g. UiAudio, GameAudio, ...
class_name AudioEnum

enum Music { NULL, MENU_DOODLE_2_LOOP, BGM}

enum Sfx { NULL, SELECT, CLICK, SELECT_2, CLICK_2 }

const MUSIC_BANK: String = "music"
const SOUND_BANK: String = "sfx"


static func music_name(music: AudioEnum.Music) -> String:
	return (AudioEnum.Music.keys()[music] as String).to_lower()


static func sfx_name(sfx: AudioEnum.Sfx) -> String:
	return (AudioEnum.Sfx.keys()[sfx] as String).to_lower()
