package
{
	import org.si.sion.utils.SiONPresetVoice;
	import org.si.sion.SiONVoice;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class VoiceManager extends Sprite 
    {
        private var _presets:SiONPresetVoice;
		private var categoryIndex:int;
		private var voiceIndex:int;
		public var voice:SiONVoice;
		public var noteArray:Array;
         
        public function VoiceManager() 
        {
            _presets = new SiONPresetVoice();
			CreateRandomInstrument();
        }
		
		public function CreateRandomInstrument():void
		{
			SetRandomVoice();
			SetRandomNoteArray();
		}
		
		public function SetRandomVoice():void
		{
			var categoryIndex:int = Math.floor(Math.random()*_presets.categolies.length);
			var voiceList:Array = _presets.categolies[categoryIndex];
			var voiceIndex:int = Math.floor(Math.random()*voiceList.length);
			
			voice = _presets["valsound.piano1"];
		}
		
		public function SetRandomNoteArray():void
		{
			var noteIndex:int = Math.floor(Math.random()*25)+48;
			var x:int
			
			noteArray = [];
			noteArray.push(noteIndex);
			for (var i:int = 0; i < 3; i++)
			{
				x = Math.floor(Math.random()*8)+1;
				noteIndex += x;
				noteArray.push(noteIndex);
			}
		}
	}
}