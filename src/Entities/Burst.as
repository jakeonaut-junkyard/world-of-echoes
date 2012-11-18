package Entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Burst extends GameSprite
	{
		private var myAlpha:Number;
		
		[Embed(source = "../resources/images/blue_burst.png")]
		private var sprite_sheet:Class;
		
		public function Burst(x:int, y:int) 
		{
			super(x, y, 0, 0, 64, 64);
			
			//animation management creation
			myAlpha = 1;
			frameDelay = 1;
			maxFrame = 15;
			frameWidth = 64;
			frameHeight = 64;
		}
		
		override public function Render():void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			super.DrawSpriteFromSheet(temp_image, temp_sheet);
			
			//RENDER IT //CREATE ALPHA
			var alpha:ColorTransform = new ColorTransform();
			alpha.alphaMultiplier = myAlpha;
			
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			matrix.scale(Global.zoom, Global.zoom); 
			Game.Renderer.draw(image_sprite, matrix, alpha);
		}
		
		public function Update():void
		{	
			if (++frameCount >= frameDelay)
			{
				myAlpha -= 0.067;
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