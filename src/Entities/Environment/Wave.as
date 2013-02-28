package Entities.Environment 
{
	import Entities.Parents.GameSprite;
	import flash.utils.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	public class Wave extends GameSprite
	{
		[Embed(source = "../../resources/images/wave_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function Wave(x:int, y:int, currFrame:int)
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			
			maxFrame = 6;
			frameWidth = 16;
			frameHeight = 16;
			frameDelay = 6;
			this.currFrame = currFrame;
			visible = true;
			foreground = true;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();

			super.DrawSpriteFromSheet(temp_image, temp_sheet);

			//RENDER IT //CREATE ALPHA
			var color:ColorTransform = new ColorTransform();
			color.alphaMultiplier = 0.8;

			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, color);
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{		
			if (currFrame == 2 || currFrame == 5) frameDelay = 12;
			else if (currFrame == 0 || currFrame == 4) frameDelay = 2;
			else frameDelay = 7;
			UpdateAnimation();
		}
	}
}