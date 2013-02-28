package Entities.Environment 
{
	import Entities.Parents.GameSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.utils.*;
	
	public class SwampTreeNode extends GameSprite
	{
		[Embed(source = "../../resources/images/swampTree_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function SwampTreeNode(x:int, y:int, height:int)
		{
			super(x, y, 0, 0, 48, 0);
			sprite_sheet = my_sprite_sheet;
			
			topDownSolid = true;
			bb = height*16+48;
			this.y-=(height*16+32);
			currAniX = Math.floor(Math.random()*2);
			
			frameWidth = 48;
			frameHeight = height*16+48;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			DrawSpriteFromSheet(temp_image, temp_sheet);
			
			//RENDER IT
			var matrix:Matrix = new Matrix();
			matrix.translate(int(x), int(y));
			levelRenderer.draw(image_sprite, matrix);
		}
		
		override public function DrawSpriteFromSheet(temp_image:Bitmap, temp_sheet:Bitmap):void
		{
			var i:int, sprite_x:int, sprite_y:int;
			for (i = 0; i < image_sprite.numChildren;i++){
				image_sprite.removeChildAt(i);
			}
			
			for (i = 0; i < frameHeight-48; i+=16){
				sprite_x = currFrame*frameWidth+currAniX*frameWidth;
				sprite_y = 80;
				temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
					new Rectangle(sprite_x, sprite_y, frameWidth, 16), 
					new Point(0,48+i)
				);
				
			}
			
			sprite_x = currFrame*frameWidth+currAniX*frameWidth;
			sprite_y = 0;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, frameWidth, 48), 
				new Point(0,0)
			);
			
			image_sprite.addChild(temp_image);
		}
	}
}