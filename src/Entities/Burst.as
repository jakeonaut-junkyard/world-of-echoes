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
	
	public class Burst extends GameSprite
	{
		public var color:ColorTransform;
		protected var myAlpha:Number;
		
		[Embed(source = "../resources/images/circle_burst.png")]
		private var sprite_sheet:Class;
		
		public function Burst(x:int, y:int, color:ColorTransform) 
		{
			super(x, y, 0, 0, 64, 64);
			
			//animation management creation
			myAlpha = 1;
			frameDelay = 1;
			maxFrame = 15;
			frameWidth = 64;
			frameHeight = 64;
			
			this.color = new ColorTransform();
			this.color.redMultiplier = color.redMultiplier;
			this.color.blueMultiplier = color.blueMultiplier;
			this.color.greenMultiplier = color.greenMultiplier;
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
		
		public function Update():void
		{		
			frameCount +=  Global.CURR_PHYSICS_SPEED;
			if (frameCount >= frameDelay)
			{
				myAlpha -= 1/maxFrame;
				if (++currFrame >= maxFrame)
				{
					visible = false;
					currFrame = 0;
				}
				frameCount = 0;
			}
		}
	}
}