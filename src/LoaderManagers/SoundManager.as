package LoaderManagers
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	public class SoundManager 
	{
		private static var _instance:SoundManager;
		private static var _allowInstance:Boolean;

		private var _musicMuted:Boolean;
		private var _music:Dictionary;
		private var _musicChannels:Dictionary;
		private var _musicVolumes:Dictionary;
		private var _masterMusicVolume:Number;

		private var _sfxMuted:Boolean;
		private var _sfx:Dictionary;
		private var _sfxChannels:Dictionary;
		private var _sfxVolumes:Dictionary;
		private var _masterSfxVolume:Number;
		
		public var Ambient_Sounds:Array;

		public function SoundManager() 
		{
			if (!_allowInstance)
				throw new Error("Use Singleton.getInstance()");

			_musicMuted = false;
			_music = new Dictionary;
			_musicChannels = new Dictionary;
			_musicVolumes = new Dictionary;
			_masterMusicVolume = 0.6;

			_sfxMuted = false;
			_sfx = new Dictionary;
			_sfxChannels = new Dictionary;
			_sfxVolumes = new Dictionary;
			_masterSfxVolume = 0.6;
			
			Ambient_Sounds = [];
		}

		public static function getInstance():SoundManager
		{
			if (_instance == null)
			{
				_allowInstance = true;
				_instance = new SoundManager();
				_allowInstance = false;
			}

			return _instance;
		}

		public function addMusic(sound:Sound, id:String):void
		{
			_music[id] = sound;
		}

		public function addSfx(sound:Sound, id:String):void
		{
			_sfx[id] = sound;
		}

		//
		//PLAY MUSIC/SOUNDS
		public function playMusic(id:String, startTime:int = 0, loops:int = 0, volume:Number = 1):void
		{
			if (_music[id] != null)
			{
				_musicVolumes[id] = volume;
				var musicTransform:SoundTransform = new SoundTransform;
				if (_musicMuted)
					musicTransform.volume = 0;
				else
					musicTransform.volume = _musicVolumes[id] * masterMusicVolume;
				_musicChannels[id] = _music[id].play(startTime, loops, musicTransform);
			}
		}

		public function playSfx(id:String, startTime:int = 0, loops:int = 0, volume:Number = 1):void
		{
			if (_sfx[id] != null)
			{
				_sfxVolumes[id] = volume;
				var sfxTransform:SoundTransform = new SoundTransform;
				if (_sfxMuted)
					sfxTransform.volume = 0;
				else
					sfxTransform.volume = _sfxVolumes[id] * masterSfxVolume;
				_sfxChannels[id] = _sfx[id].play(startTime, loops, sfxTransform);
			}
		}

		//
		//STOP MUSIC/SOUNDs
		public function stopMusic(id:String):void
		{
			if (_musicChannels[id] != null)
			{
				_musicChannels[id].stop();
				delete _musicChannels[id];
			}
		}

		public function stopSfx(id:String):void
		{
			if (_sfxChannels[id] != null)
			{
				_sfxChannels[id].stop();
				delete _sfxChannels[id];
			}
		}

		public function stopAllMusic():void
		{
			for (var id:String in _musicChannels)
			{
				stopMusic(id);
			}
		}
		
		public function stopAllAmbientSounds():void
		{
			for (var ambientSound:String in Ambient_Sounds){
				stopSfx(ambientSound);
			}
		}

		public function stopAllSfx():void
		{
			for (var id:String in _sfxChannels)
			{
				stopSfx(id);
			}
		}

		//
		//HANDLE SOUND/MUSIC VOLUMES
		public function changeMusicVolume(id:String, volume:Number):void
		{
			if (_musicChannels[id] != null && _musicVolumes[id] != null)
			{
				if (volume < 0)
					volume = 0;
				else if (volume > 1)
					volume = 1;

				_musicVolumes[id] = volume;
				var musicTransform:SoundTransform = new SoundTransform;
				if (_musicMuted)
						musicTransform.volume = 0;
					else
						musicTransform.volume = _musicVolumes[id] * _masterMusicVolume;
				_musicChannels[id].soundTransform = musicTransform;
			}
		}

		public function changeSfxVolume(id:String, volume:Number):void
		{
			if (_sfxChannels[id] != null && _sfxVolumes[id] != null)
			{
				if (volume < 0)
					volume = 0;
				else if (volume > 1)
					volume = 1;

				_sfxVolumes[id] = volume;
				var sfxTransform:SoundTransform = new SoundTransform;
				if (_sfxMuted)
					sfxTransform.volume = 0;
				else
					sfxTransform.volume = _sfxVolumes[id] * masterSfxVolume;
				_sfxChannels[id].soundTransform = sfxTransform;
			}
		}

		//
		//DEALING WITH MUTING AND UNMUTING SOUNDS/MUSICS
		public function toggleMuteMusic():void
		{
			_musicMuted = !_musicMuted;
			masterMusicVolume = masterMusicVolume;
		}

		public function toggleMuteSfx():void
		{
			_sfxMuted = !_sfxMuted;
			masterSfxVolume = masterSfxVolume;
		}

		public function unmuteAllMusic():void
		{
			_musicMuted = false;
			masterMusicVolume = masterMusicVolume;
		}

		public function unmuteAllSfx():void
		{
			_sfxMuted = false;
			masterSfxVolume = masterSfxVolume;
		}

		public function muteAllMusic():void
		{
			_musicMuted = true;
			masterMusicVolume = masterMusicVolume;
		}

		public function muteAllSfx():void
		{
			_sfxMuted = true;
			masterSfxVolume = masterSfxVolume;
		}

		//
		//GETTER AND SETTER FOR MASTERSFXVOLUME AND MASTER MUSIC VOLUME
		public function get masterMusicVolume():Number
		{
			return _masterMusicVolume;
		}

		public function set masterMusicVolume(volume:Number):void
		{
			if (volume < 0)
				volume = 0;
			else if (volume > 1)
				volume = 1;

			_masterMusicVolume = volume;

			for (var id:String in _musicChannels)
			{
				if (_musicVolumes[id] != null)
				{
					var musicTransform:SoundTransform = new SoundTransform;
					if (_musicMuted)
						musicTransform.volume = 0;
					else
						musicTransform.volume = _musicVolumes[id] * _masterMusicVolume;
					_musicChannels[id].soundTransform = musicTransform;
				}
			}
		}

		public function get masterSfxVolume():Number
		{
			return _masterSfxVolume;
		}

		public function set masterSfxVolume(volume:Number):void
		{
			if (volume < 0)
				volume = 0;
			else if (volume > 1)
				volume = 1;

			_masterSfxVolume = volume;

			for (var id:String in _sfxChannels)
			{
				var sfxTransform:SoundTransform = new SoundTransform;
				if (_sfxMuted)
					sfxTransform.volume = 0;
				else
					sfxTransform.volume = _sfxVolumes[id] * masterSfxVolume;
				_sfxChannels[id].soundTransform = sfxTransform;
			}
		}
	}
}