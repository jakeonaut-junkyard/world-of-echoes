package Entities.GoldBugs 
{
	import Entities.Parents.GameSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class GoldTwinkle extends GameSprite
	{
		public var color:ColorTransform;
		protected var myAlpha:Number;

		[Embed(source = "../../resources/images/gold_twinkle_sheet.png")]
		private var my_sprite_sheet:Class;

		public function GoldTwinkle(x:int, y:int) 
		{
			super(x, y, 0, 0, 3, 3);

			//animation management creation
			sprite_sheet = my_sprite_sheet;
			frameDelay = 2;
			maxFrame = 5;
			frameWidth = 3;
			frameHeight = 3;
		}

		public function Update(entities:Array, map:Array):void
		{		
			frameCount +=  Global.CURR_PHYSICS_SPEED;
			if (frameCount >= frameDelay)
			{
				if (++currFrame >= maxFrame)
				{
					visible = false;
					delete_me = true;
					currFrame = 0;
				}
				frameCount = 0;
			}
		}
	}
}