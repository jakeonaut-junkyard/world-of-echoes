package LoaderManagers 
{
	import org.si.sion.utils.SiONPresetVoice;
	import org.si.sion.SiONVoice;
	
	public class VoiceManager 
	{
		private var _presets:SiONPresetVoice;
		public var voice:SiONVoice;
		public var noteArray:Array;
		
		public function VoiceManager() 
		{
			_presets = new SiONPresetVoice();
			voice = (_presets.categolies[0])[0];
			noteArray = [];
		}
		
		public function SetVoice(categoryIndex:int, voiceIndex:int):void
		{
			var voiceList:Array = _presets.categolies[categoryIndex];
			voice = voiceList[voiceIndex];
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
			SetRandomNoteArray(scale, newIndex);
		}
	}
}