package
{
	import org.si.sion.utils.SiONPresetVoice;
	import org.si.sion.SiONVoice;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class VoiceManager extends Sprite 
    {
        private var _presets:SiONPresetVoice;
		public var voice:SiONVoice;
		public var noteArray:Array;
		public var color:ColorTransform;
         
        public function VoiceManager() 
        {
            _presets = new SiONPresetVoice();
			CreateRandomInstrument();
        }
		
		public function CreateRandomInstrument():void
		{
			SetRandomVoice();
			SetRandomNoteArray();
			SetRandomColor();
		}
		
		public function SetRandomVoice():void
		{
			var categoryIndex:int = Math.floor(Math.random()*_presets.categolies.length);
			var voiceList:Array = _presets.categolies[categoryIndex];
			var voiceIndex:int = Math.floor(Math.random()*voiceList.length);
			trace("Voice: ["+categoryIndex+"]["+voiceIndex+"]");
			
			voice = voiceList[voiceIndex];
		}
		
		public function SetRandomNoteArray():void
		{
			var noteIndex:int = Math.floor(Math.random()*25)+40;
			var x:int
			
			noteArray = [];
			noteArray.push(noteIndex);
			for (var i:int = 0; i < 7; i++)
			{
				x = Math.floor(Math.random()*4)+1;
				noteIndex += x;
				noteArray.push(noteIndex);
			}
		}
		
		public function SetRandomColor():void
		{
			color = new ColorTransform();
			color.redMultiplier = Math.random()*4;
			color.blueMultiplier = Math.random()*4;
			color.greenMultiplier = Math.random()*4;
		}
	}
}