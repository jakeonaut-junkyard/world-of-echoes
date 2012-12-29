package Entities.Field 
{
	import Entities.Parents.GameSprite;
	import Entities.Avatar;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Butterfly extends GameSprite
	{
		[Embed(source = "../../resources/images/field/butterfly.png")]
		private var sprite_sheet:Class;
		
		private var base_x:int;
		private var base_y:int;
		private var xvel:Number;
		private var yvel:Number;
		private var moveCounterX:int;
		private var moveCounterY:int;
		private var facing:int;
		
		public function Butterfly(x:int, y:int)
		{
			super(x, y, 0, 0, 8, 8);
			
			base_x = x;
			base_y = y;
			
			moveCounterX = 4;
			moveCounterY = 3;
			facing = Global.RIGHT;
			xvel = (1-Math.floor(Math.random()*3));
			yvel = (1-Math.floor(Math.random()*3));
			if (xvel < 0) facing = Global.LEFT;
			
			//image stuff
			currAniY = Math.floor(Math.random()*4);
			
			frameDelay = 4;
			frameCount = Math.floor(Math.random()*2);
			maxFrame = 2;
			frameWidth = 8;
			frameHeight = 8;
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
		
		public function Update(avatar:Avatar, solids:Array):void
		{	
			var avatar_distance:int = Math.abs((x+rb/2)-(avatar.x+avatar.rb/2));
			if (avatar_distance >= 300) return;
			
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
				
				moveCounterX = 4;
			}
			if (moveCounterY <= 0){
				yvel = (1-Math.floor(Math.random()*3));
				if (y >= base_y+8) yvel = -1;
				else if (y <= base_y-8) yvel = 1;
				
				moveCounterY = 3;
			}
		}
		
		public function UpdateMoveFromAvatar(avatar:Avatar):void
		{
			if (CheckRectIntersect(avatar, x+lb-8, y+tb-8, x+rb+8, y+bb+8)){
				yvel = -1;
			}
		}
	}
}