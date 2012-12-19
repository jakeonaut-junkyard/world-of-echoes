package Entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.si.sion.sequencer.SiMMLTrack;
	
	public class BassSquare extends GameSprite
	{
		public var _voice:VoiceManager;
		protected var myAlpha:Number;
		protected var trackId:int = Global.BASS_SQUARE_TRACK_ID;
		
		[Embed(source = "../resources/images/bass_square.png")]
		private var sprite_sheet:Class;
		
		public function BassSquare(x:int, y:int, voice:VoiceManager) 
		{
			super(x, y, 0, 0, 20, 20);
			
			//animation management creation
			myAlpha = 1;
			frameDelay = 1;
			maxFrame = 34;
			frameWidth = 20;
			frameHeight = 20;
			
			currFrame = Math.round(Math.random()*maxFrame);
			
			_voice = new VoiceManager();
			_voice.voice = voice.voice;
			_voice.color = new ColorTransform();
			_voice.color.redMultiplier = voice.color.blueMultiplier;
			_voice.color.blueMultiplier = voice.color.greenMultiplier;
			_voice.color.greenMultiplier = voice.color.redMultiplier;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			super.DrawSpriteFromSheet(temp_image, temp_sheet);
			
			//RENDER IT //CREATE ALPHA
			_voice.color.alphaMultiplier = myAlpha;
			
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, _voice.color);
		}
		
		public function Update(avatar:Avatar, bassScaleArray:Array):void
		{
			if (CheckRectIntersect(avatar, x+lb, y+tb, x+rb, y+bb))
			{
				visible = false;
				
				var index:int = Math.round(Math.random()*bassScaleArray.length);
				var noteIndex:int = bassScaleArray[index];
				var tempNote:SiMMLTrack = Game._driver.noteOn(noteIndex, _voice.voice, 8, 0, 0, trackId);
				tempNote.masterVolume = 128;
			}
			
			if (++frameCount >= frameDelay)
			{
				if (++currFrame >= maxFrame)
				{
					currFrame = 0;
				}
				frameCount = 0;
			}
		}
	}
}