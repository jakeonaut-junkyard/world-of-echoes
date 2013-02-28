package Entities.Environment 
{
	import Entities.Avatar;
	import Entities.Parents.GameSprite;
	import Entities.Parents.PlayerFollower;
	import LoaderManagers.SoundManager;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Cicada extends GameSprite
	{
		[Embed(source = "../../resources/images/cicada_sheet.png")]
		private var my_sprite_sheet:Class;
		private var buzzTimer:int;
		
		private var vel:Point;
		private var flyAway:Boolean;
		private var myAlpha:Number;
		
		private var lastAniY:int;
		private var glitchTimer:int = 0;
		private var glitched:Boolean = false;
		
		public function Cicada(x:int, y:int, currAniY:int) 
		{
			super(x, y, 0, 0, 8, 8);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 1;
			frameWidth = 8;
			frameHeight = 8;
			frameDelay = 2;
			this.currAniY = currAniY;
			lastAniY = currAniY;
			
			myAlpha = 1;
			buzzTimer = 30+Math.floor(Math.random()*50);
			vel = new Point(0, 0);
			flyAway = false;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();

			super.DrawSpriteFromSheet(temp_image, temp_sheet);

			//RENDER IT //CREATE ALPHA
			var color:ColorTransform = new ColorTransform();
			color.alphaMultiplier = myAlpha;

			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, color);
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{			
			var speed:Number = 2.0;
			UpdateAnimation();
			if (flyAway){
				if (vel.y > -speed*1.5) vel.y -= 0.5;
				if (vel.x > 0) vel.x -= 0.1;
				else vel.x += 0.1;
				
				x += vel.x;
				y += vel.y;
				myAlpha -= 0.05;
				if (myAlpha <= 0) delete_me = true;
				return;
			}
			
			GlitchUp();
			CicadaBuzz();
			GetScaredAway(entities);
		}
		
		public function CicadaBuzz():void
		{
			buzzTimer--;
			if (buzzTimer <= 0){
				var repeat:int = Math.floor(Math.random()*7)+4;
				var pitch:int = Math.floor(Math.random()*3)+1;
				switch(pitch){
					case 1: 
						SoundManager.getInstance().playSfx("Cicada1Ambience", -5, repeat);
						break;
					case 2:
						SoundManager.getInstance().playSfx("Cicada2Ambience", -5, repeat);
						break;
					case 3:
						SoundManager.getInstance().playSfx("Cicada3Ambience", -5, repeat);
						break;
					default: break;
				}
				buzzTimer = 30+Math.floor(Math.random()*50);
			}
		}
		
		public function GlitchUp():void
		{
			glitchTimer--;
			if (glitchTimer <= 0){
				if (glitched){
					currAniY = lastAniY;
					glitchTimer = Math.floor(Math.random()*50)+100;
				}else{
					if (Math.floor(Math.random()*4) <= 0){
						lastAniY = currAniY;
						glitched = true;
						currAniY = Math.floor(Math.random()*3)+lastAniY+1;
						if (currAniY >= 4) currAniY -= 4;
						glitchTimer = 2;
					}
				}
				glitched = !glitched;
			}
		}
		
		public function GetScaredAway(entities:Array):void
		{
			var speed:Number = 2.0;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Avatar || (entities[i] is PlayerFollower && entities[i].followingPlayer)){
					if (CheckRectIntersect(entities[i], x-8, y-8, x+16, y+16) || GameWorld.environment.rain){
						if (entities[i].x > x){
							vel.x = -speed;
						}else if (entities[i].x < x){
							vel.x = speed;
						}
						vel.y = speed/2;
						flyAway = true;
						maxFrame = 2;
						isDisposable = true;
						
						var pitch:int = Math.floor(Math.random()*3)+1;
						switch(pitch){
							case 1: 
								SoundManager.getInstance().playSfx("Cicada1Death", -5, 1);
								break;
							case 2:
								SoundManager.getInstance().playSfx("Cicada2Death", -5, 1);
								break;
							case 3:
								SoundManager.getInstance().playSfx("Cicada3Death", -5, 1);
								break;
							default: break;
						}
						break;
					}
				}
			}
		}
	}
}