package Entities.Beach 
{
	import Entities.Parents.GameMover;
	import Entities.Avatar;
	import LoaderManagers.SoundManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class Seagull extends GameMover
	{
		[Embed(source = "../../resources/images/beach/seagull_sheet.png")]
		private var my_sprite_sheet:Class;
		
		private var base_x:int;
		private var base_y:int;
		private var xvel:Number;
		private var yvel:Number;
		private var moveCounterX:int;
		private var moveCounterY:int;
		private var cawTimer:int;
		
		public function Seagull(x:int, y:int)
		{
			super(x, y, 0, 0, 16, 16);
			
			base_x = x;
			base_y = y;
			cawTimer = Math.floor(Math.random()*25)+30;
			
			moveCounterX = 6;
			moveCounterY = 5;
			facing = Global.RIGHT;
			xvel = (1-Math.floor(Math.random()*3));
			yvel = (1-Math.floor(Math.random()*3));
			if (xvel < 0) facing = Global.LEFT;
			
			//image stuff
			sprite_sheet = my_sprite_sheet;
			
			frameDelay = 6;
			frameCount = Math.floor(Math.random()*2);
			maxFrame = 2;
			frameWidth = 16;
			frameHeight = 16;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			super.DrawSpriteFromSheet(temp_image, temp_sheet);
			
			//RENDER IT
			var matrix:Matrix = new Matrix();
			if (facing == Global.LEFT)
			{
				matrix.scale(-1, 1);
				matrix.translate(frameWidth, 0);
			}
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix);
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{	
			var avatar:Avatar;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Avatar) {
					avatar = entities[i];
					break;
				}
			}
			
			var avatar_distance:int = Math.abs((x+rb/2)-(avatar.x+avatar.rb/2));
			if (avatar_distance >= 300) return;
			
			cawTimer--;
			if (cawTimer <= 0){
				SoundManager.getInstance().playSfx("SeagullSound", 0, 1);
				cawTimer = Math.floor(Math.random()*25)+30;
			}
			
			UpdateMoveTimerMove();
			UpdateMoveFromAvatar(avatar);
			
			x+=xvel;
			y+=yvel;
			super.UpdateAnimation();
		}
		
		public function UpdateMoveTimerMove():void
		{
			moveCounterX-=Global.CURR_PHYSICS_SPEED;
			moveCounterY-=Global.CURR_PHYSICS_SPEED;
			if (moveCounterX <= 0){
				xvel = (1-Math.floor(Math.random()*3));
				if (x >= base_x+8) xvel = -1;
				else if (x <= base_x-8) xvel = 1;
				
				if (xvel < 0) facing = Global.LEFT;
				else if (xvel > 0) facing = Global.RIGHT;
				
				moveCounterX = 6;
			}
			if (moveCounterY <= 0){
				yvel = (1-Math.floor(Math.random()*3));
				if (y >= base_y+8) yvel = -1;
				else if (y <= base_y-8) yvel = 1;
				
				moveCounterY = 5;
			}
		}
		
		public function UpdateMoveFromAvatar(avatar:Avatar):void
		{
			if (avatar.vel.x == 0 && avatar.vel.y == 0) return;
			if (CheckRectIntersect(avatar, x+lb-8, y+tb-8, x+rb+8, y+bb+8)){
				yvel = -1;
			}
		}
	}
}