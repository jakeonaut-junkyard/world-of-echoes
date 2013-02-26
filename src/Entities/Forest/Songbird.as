package Entities.Forest 
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
	
	public class Songbird extends GameSprite
	{
		[Embed(source = "../../resources/images/songbird_sheet.png")]
		private var my_sprite_sheet:Class;
		private var singTimer:int;
		private var hopTimer:int;
		private var baseX:int;
		
		private var vel:Point;
		private var flyAway:Boolean;
		private var myAlpha:Number;
		private var facing:int;
		
		public function Songbird(x:int, y:int, currAniY:int) 
		{
			super(x, y, 0, 0, 8, 7);
			sprite_sheet = my_sprite_sheet;
			maxFrame = 1;
			frameWidth = 16;
			frameHeight = 16;
			frameDelay = 2;
			this.currAniY = currAniY + Math.floor(Math.random()*4);
			
			myAlpha = 1;
			singTimer = 50+Math.floor(Math.random()*50);
			hopTimer = 0;
			baseX = x;
			vel = new Point(0, 0);
			flyAway = false;
			
			facing = Global.RIGHT;
			if (Math.floor(Math.random()*2) <= 0) 
				facing = Global.LEFT;
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
			if (facing == Global.LEFT)
			{
				matrix.scale(-1, 1);
				matrix.translate(frameWidth, 0);
			}
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, color);
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{			
			var speed:Number = 3.0;
			UpdateAnimation();
			if (flyAway){
				if (vel.y > -speed*1.5) vel.y -= 1;
				if (vel.x > 0) vel.x -= 0.05;
				else vel.x += 0.05;
				
				x += vel.x;
				y += vel.y;
				myAlpha -= 0.025;
				if (myAlpha <= 0) delete_me = true;
				return;
			}
			singTimer--;
			if (singTimer <= 0){
				var repeat:int = Math.floor(Math.random()*3)+1;
				var pitch:int = Math.floor(Math.random()*3)+1;
				var chirp:Boolean = (Math.floor(Math.random()*2) <= 0);
				switch(pitch){
					case 1: 
						if (chirp) SoundManager.getInstance().playSfx("BirdChirp1Sound", -5, repeat);
						else SoundManager.getInstance().playSfx("BirdCheep1Sound", -5, repeat);
						break;
					case 2:
						if (chirp) SoundManager.getInstance().playSfx("BirdChirp2Sound", -5, repeat);
						else SoundManager.getInstance().playSfx("BirdCheep2Sound", -5, repeat);
						break;
					case 3:
						if (chirp) SoundManager.getInstance().playSfx("BirdChirp3Sound", -5, repeat);
						else SoundManager.getInstance().playSfx("BirdCheep3Sound", -5, repeat);
						break;
					default: break;
				}
				singTimer = 50+Math.floor(Math.random()*50);
			}
			hopTimer--;
			if (hopTimer <= 0){
				if (Math.floor(Math.random()*2) <= 0){
					vel.x = 0; 
					currFrame = 0;
					maxFrame = 1;
				}else{
					vel.x = (Math.floor(Math.random()*3)-1)*speed/2;
					if (vel.x != 0){ 
						currFrame = 1;
						maxFrame = 2;
					}else{
						currFrame = 0;
						maxFrame = 1;
					}
				}
				hopTimer = Math.floor(Math.random()*30)+20;
			}
			if (x > baseX+24) baseX+=240;
			else if (x < baseX) baseX-=240;
			if ((vel.x > 0 && x+rb+vel.x > baseX+24) || (vel.x < 0 && x+vel.x < baseX)){
				vel.x = -vel.x;
			}if (vel.x > 0) facing = Global.RIGHT;
			else if (vel.x < 0) facing = Global.LEFT;
			x += vel.x;
			
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Avatar || (entities[i] is PlayerFollower && entities[i].followingPlayer)){
					if (CheckRectIntersect(entities[i], x-16, y-16, x+rb+16, y+bb+16) || GameWorld.environment.rain){
						if (entities[i].x > x){
							vel.x = -speed;
							facing = Global.LEFT;
						}else if (entities[i].x < x){
							vel.x = speed;
							facing = Global.RIGHT;
						}
						vel.y = -speed/3;
						flyAway = true;
						currAniX = 2;
						maxFrame = 2;
						SoundManager.getInstance().playSfx("BirdFlapSound", -5, 1);
						break;
					}
				}
			}
		}
	}
}