package Entities 
{
	import Entities.Parents.GameSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;

	public class Burst extends GameSprite
	{
		public var color:ColorTransform;
		protected var myAlpha:Number;

		[Embed(source = "../resources/images/circle_burst.png")]
		private var my_sprite_sheet:Class;

		public function Burst(x:int, y:int) 
		{
			super(x, y, 0, 0, 48, 48);
			isDisposable = true;

			//animation management creation
			sprite_sheet = my_sprite_sheet;
			myAlpha = 1;
			frameDelay = 1;
			maxFrame = 15;
			frameWidth = 48;
			frameHeight = 48;

			color = new ColorTransform();
			color.redMultiplier = Math.floor(Math.random()*3);
			color.blueMultiplier = Math.floor(Math.random()*3);
			color.greenMultiplier = Math.floor(Math.random()*3);
		}

		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();

			super.DrawSpriteFromSheet(temp_image, temp_sheet);

			//RENDER IT //CREATE ALPHA
			color.alphaMultiplier = myAlpha;

			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, color);
		}

		override public function Update(entities:Array, map:Dictionary):void
		{		
			frameCount +=  Global.CURR_PHYSICS_SPEED;
			if (frameCount >= frameDelay)
			{
				myAlpha -= 1/maxFrame;
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