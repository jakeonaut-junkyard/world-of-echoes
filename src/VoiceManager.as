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
         
        public function VoiceManager(scale:Array)
        {
            _presets = new SiONPresetVoice();
			CreateRandomInstrument(scale);
        }
		
		public function CreateRandomInstrument(scale:Array):void
		{
			SetRandomVoice();
			SetRandomNoteArray(scale);
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
		
		public function SetRandomNoteArray(scale:Array):void
		{
			var index:int = Math.floor(Math.random()*Math.floor(scale.length/2));
			var x:int;
			var maxIndex:int = scale.length;
			var randomRange:int = 4;
			while (randomRange*8+index >= maxIndex)
				randomRange--;
			
			noteArray = [];
			noteArray.push(scale[index]);
			for (var i:int = 0; i < 7; i++)
			{
				x = Math.floor(Math.random()*randomRange)+1;
				index += x;
				noteArray.push(scale[index]);
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