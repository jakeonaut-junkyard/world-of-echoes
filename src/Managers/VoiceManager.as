package Managers
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
		public var scaleArray:Array;
		public var color:ColorTransform;
         
        public function VoiceManager()
        {
            _presets = new SiONPresetVoice();
			voice = (_presets.categolies[0])[0];
			noteArray = [];
			scaleArray = [];
			color = new ColorTransform();
        }
		
		public function CreateRandomInstrument(scale:Array):void
		{
			SetRandomVoice();
			SetRandomNoteArray(scale);
			SetRandomColor();
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
		
		public function SetNoteArray(array:Array):void
		{
			noteArray = [];
			for (var i:int = 0; i < array.length; i++)
			{
				noteArray.push(array[i]);
			}
		}
		
		public function SetRandomNoteArray(scale:Array = null, baseNote:int = -1):void
		{
			if (scale == null) scale = scaleArray;
			else scaleArray = scale;
			
			var index:int = Math.floor(Math.random()*Math.floor(scale.length/2));
			if (baseNote > -1) index = baseNote;
			
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
		
		public function SetRandomColor():void
		{
			color = new ColorTransform();
			var red:Number;
			var blue:Number;
			var green:Number;
			
			var rgb:int = Math.floor(Math.random()*3);
			switch(rgb)
			{
				case 0:			
					red = Math.random()*4;
					var bg:int = Math.floor(Math.random()*2);
					if (bg == 0)
					{
						blue = Math.random()*(4-(4-red))+(4-red);
						green = Math.random()*(4-(4-blue))+(4-blue);
					}
					else
					{
						green = Math.random()*(4-(4-red))+(4-red);
						blue = Math.random()*(4-(4-green))+(4-green);
					}
					break;
				case 1:
					blue = Math.random()*4;
					var rg:int = Math.floor(Math.random()*2);
					if (rg == 0)
					{
						red = Math.random()*(4-(4-blue))+(4-blue);
						green = Math.random()*(4-(4-red))+(4-red);
					}
					else
					{
						green = Math.random()*(4-(4-blue))+(4-blue);
						red = Math.random()*(4-(4-green))+(4-green);
					}
					break;
				case 2:
					green = Math.random()*4;
					var rb:int = Math.floor(Math.random()*2);
					if (rb == 0)
					{
						red = Math.random()*(4-(4-green))+(4-green);
						blue = Math.random()*(4-(4-red))+(4-red);
					}
					else
					{
						blue = Math.random()*(4-(4-green))+(4-green);
						red = Math.random()*(4-(4-blue))+(4-blue);
					}
					break;
			}
			
			color.redMultiplier = red;
			color.blueMultiplier = blue;
			color.greenMultiplier = green;
		}
	}
}