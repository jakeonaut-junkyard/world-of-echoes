package Entities.SoundObjects 
{
	import org.si.sion.SiONDriver;
	
	public class SoundObject 
	{
		public var voice:VoiceManager;
		public var noteCount:int;
		public var noteDelay:int;
		public var dead:Boolean = false;
		
		public function SoundObject(voice:VoiceManager) 
		{
			this.voice = new VoiceManager([]);
			this.voice.voice = voice.voice;
			this.voice.noteArray = voice.noteArray;
			
			noteCount = 0;
			noteDelay = 10;
		}		
		
		public function Update():void
		{
		}
	}
}