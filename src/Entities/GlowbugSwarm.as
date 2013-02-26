package Entities 
{
	import Entities.Parents.GameSprite;
	import LoaderManagers.VoiceManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class GlowbugSwarm extends GameSprite
	{		
		public var playedNote:Boolean;
		public var holdArray:Array;
		public var humPositions:Array;
		public var relPositions:Array;
		protected var _voice:VoiceManager;
		
		[Embed(source = "../resources/images/glowBug_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function GlowbugSwarm(x:int, y:int) 
		{
			super(x, y, 2, 2, 14, 14);
			playedNote = false;
			
			_voice = new VoiceManager();
			_voice.SetVoice(7, 5);
			humPositions = [];
			humPositions.push([8, -4, new Point(1, 0)]);
			humPositions.push([20, 8, new Point(0, 1)]);
			humPositions.push([8, 20, new Point(-1, 0)]);
			humPositions.push([-4, 8, new Point(1, 0)]);
			humPositions.push([17.414, -1.414, new Point(0, 0)]);
			humPositions.push([17.414, 17.414, new Point(0, 0)]);
			humPositions.push([-1.414, 17.414, new Point(0, 0)]);
			humPositions.push([-1.414, -1.414, new Point(0, 0)]);
			
			relPositions = [];
			relPositions.push([8, -4, new Point(1, 0)]);
			relPositions.push([20, 8, new Point(0, 1)]);
			relPositions.push([8, 20, new Point(-1, 0)]);
			relPositions.push([-4, 8, new Point(1, 0)]);
			relPositions.push([17.414, -1.414, new Point(0, 0)]);
			relPositions.push([17.414, 17.414, new Point(0, 0)]);
			relPositions.push([-1.414, 17.414, new Point(0, 0)]);
			relPositions.push([-1.414, -1.414, new Point(0, 0)]);
			holdArray = [];
			
			//animation management creation
			sprite_sheet = my_sprite_sheet;
			frameDelay = 7;
			maxFrame = 2;
			frameWidth = 3;
			frameHeight = 3;
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{	
			var i:int;
			_voice.TranslateNoteArray(Game._SiONArray);
			if (Global.CheckKeyPressed(Global.ENTER)){
				_voice.SetRandomVoice();
			}
			for (i = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					FollowPlayerHum(entities[i]);
					break;
				}
			}
			UpdateAnimation();
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			for (var i:int = 0; i < relPositions.length; i++){
				for (var j:int = 0; j < image_sprite.numChildren; j++){
					image_sprite.removeChildAt(j);
				}
				var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
				var temp_sheet:Bitmap = new sprite_sheet();
				
				var sprite_x:int = ((i%2)+currFrame);
				if (sprite_x >= maxFrame) sprite_x = 0;
				sprite_x *= frameWidth;
				var sprite_y:int = 0;
				temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
					new Rectangle(sprite_x, sprite_y, frameWidth, frameHeight),
					new Point(0, 0));
				image_sprite.addChild(temp_image);
			
				var matrix:Matrix = new Matrix();
				matrix.translate(int(x+relPositions[i][0]), int(y+relPositions[i][1]));
				levelRenderer.draw(image_sprite, matrix);
			}
		}
		
		public function FollowPlayerHum(avatar:Avatar):void
		{
			var a:Number = 0.2;
			var i:int;
			var center:Point = new Point(8, 8);
			for (i = holdArray.length; i < relPositions.length; i++){
				var currX:Number = relPositions[i][0];
				var currY:Number = relPositions[i][1];
				var newVel:Point = relPositions[i][2];
				if (currX > 8) newVel.x -= a;
				else if (currX < 8) newVel.x += a;
				else{
					if (currY > 8) newVel.x -= a;
					else newVel.x += a;
				}if (currY > 8) newVel.y -= a;
				else if (currY < 8) newVel.y += a;
				else{
					if (currX > 8) newVel.y += a;
					else newVel.y -= a;
				}
				relPositions[i][2] = newVel;
				relPositions[i][0] += relPositions[i][2].x;
				relPositions[i][1] += relPositions[i][2].y;
			}
			for (i = holdArray.length-1; i >= 0; i--){
				relPositions[i][0] = humPositions[i][0];
				relPositions[i][1] = humPositions[i][1];
				relPositions[i][2] = new Point(0, 0);
				if (avatar.on_ground){
					Game._driver.noteOff(holdArray[i]);
					holdArray.splice(i, 1);
				}
			}
			
			if (GameWorld.pInput.playedNote){
				//var index:int = Math.floor(Math.random()*_voice.noteArray.length);
				var index:int = holdArray.length;
				Game._driver.noteOff(_voice.noteArray[index]);
				Game._driver.noteOn(_voice.noteArray[index], _voice.voice, 0);
				holdArray.push(_voice.noteArray[index]);
			}
		}
	}
}