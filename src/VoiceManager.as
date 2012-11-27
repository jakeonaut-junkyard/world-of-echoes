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
		
		public function SetRandomNoteArray(scale:Array, baseNote:int = -1):void
		{
			trace("Seed: "+baseNote);
			var index:int = Math.floor(Math.random()*Math.floor(scale.length/2));
			if (baseNote > -1)
				index = baseNote;
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
			trace("noteArray[0]: "+noteArray[0]);
		}
		
		public function TranslateNoteArray(scale:Array):void
		{
			var diff:int = 100;
			var newIndex:int = 0;
			for (var j:int = 0; j < scale.length; j++)
			{
				var newdiff:int = Math.abs(noteArray[0]-scale[j]);
				if (newdiff < diff)
				{
					diff = newdiff;
					newIndex = j;
				}
			}
			trace("base note: "+newIndex);
			SetRandomNoteArray(scale, newIndex);
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