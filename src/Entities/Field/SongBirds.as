package Entities.Field 
{
	import Managers.VoiceManager;
	import Entities.Parents.GameSprite;
	import Entities.Avatar;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.si.sion.sequencer.SiMMLTrack;
	
	public class SongBirds extends GameSprite
	{
		[Embed(source = "../../resources/images/field/songBirds.png")]
		private var sprite_sheet:Class;
		private var sing:Boolean = false;
		
		private var _voice:VoiceManager;
		private var lastNote:int = -1;
		
		public function SongBirds()
		{
			super(58, 49, 0, 0, 180, 40);
			
			_voice = new VoiceManager();
			_voice.SetVoice(16, 9);
			_voice.SetNoteArray([72, 74, 76, 77, 79, 81, 83, 84]);
			
			//image stuff
			frameDelay = Math.floor(Math.random()*10)+5;
			maxFrame = 1;
			frameWidth = 180;
			frameHeight = 40;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			DrawSpriteFromSheet(temp_image, temp_sheet);
			
			super.Render(levelRenderer);
		}
		
		override public function DrawSpriteFromSheet(temp_image:Bitmap, temp_sheet:Bitmap):void
		{
			for (var i:int = 0; i < image_sprite.numChildren;i++){
				image_sprite.removeChildAt(i);
			}
			
			var sprite_x:int = currAniX*frameWidth;
			var sprite_y:int = currFrame*frameHeight+currAniY*frameHeight;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, frameWidth, frameHeight), 
				new Point(0,0)
			);
			
			image_sprite.addChild(temp_image);
		}
		
		public function Update(avatar:Avatar, solids:Array):void
		{
			var avatar_distance:int = Math.abs((x+rb/2)-(avatar.x+avatar.rb/2));
			if (avatar_distance >= 300) return;
			
			frameCount += Global.CURR_PHYSICS_SPEED;
			if (frameCount >= frameDelay)
			{
				if (++currFrame >= maxFrame)
				{
					if (sing){
						var rand:int = Math.floor(Math.random()*8);
						if (rand == lastNote) rand++;
						if (rand >= 8) rand = 6;
						lastNote = rand;
						
						var track:SiMMLTrack = Game._driver.noteOn(_voice.noteArray[rand], _voice.voice, 4);
						track.masterVolume = 64-avatar_distance/5;
						currFrame = rand+1;
						frameDelay = 15;
					}
					else{
						currFrame = 0;
						frameDelay = Math.floor(Math.random()*10);
					}
					sing = !sing;
				}
				frameCount = 0;
			}
		}
	}
}