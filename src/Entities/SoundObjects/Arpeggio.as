package Entities.SoundObjects 
{
	import org.si.sion.SiONDriver;
	
	public class Arpeggio extends SoundObject
	{
		public var index:int;
		
		public function Arpeggio(voice:VoiceManager) 
		{
			super(voice);

			index = 0;
			noteCount = 2;
			noteDelay = 2;
		}
		
		override public function Update(driver:SiONDriver):void
		{
			if (dead) return;
			
			if (++noteCount >= noteDelay)
			{
				noteCount = 0;
				
				driver.noteOff(voice.noteArray[index], 0, 0, 0, true);
				driver.noteOn(voice.noteArray[index], voice.voice, 4);
				
				index+=2;
				if (index >= voice.noteArray.length)
					dead = true;
			}
		}
	}
}