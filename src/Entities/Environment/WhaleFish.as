package Entities.Environment 
{
	import Entities.Parents.GameMover;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class WhaleFish extends GameMover
	{
		[Embed(source = "../../resources/images/whalefish_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function WhaleFish(x:int, y:int, dir:int)
		{
			super(x, y, 0, 0, 96, 48);
			sprite_sheet = my_sprite_sheet;
			vel.x = 1+Math.floor(Math.random()*3)*0.5;
			if (dir == Global.RIGHT) vel.x *= -1;
			
			facing = Global.RIGHT;
			if (vel.x < 0) facing = Global.LEFT;
			
			currAniY = Math.floor(Math.random()*2);
			//topDownSolid = true;
			isDisposable = true;
			frameWidth = 96;
			frameHeight = 48;
			maxFrame = 2;
			frameDelay = 15;
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{
			x += vel.x;
			y += vel.y;
			UpdateAnimation();
		}
	}
}