package Entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jake Trower
	 */
	public class GameSprite extends GameObject
	{
		public var visible:Boolean;
		
		protected var image:BitmapData;
		public var image_sprite:Sprite;
		
		//animation stuff
		public var frameCount:int;
		public var frameDelay:int;
		public var currFrame:int;
		public var currAniX:int;
		public var currAniY:int;
		public var maxFrame:int;
		public var frameWidth:int;
		public var frameHeight:int;
		
		public function GameSprite(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int) 
		{
			//basic collision/placement stuff
			super(x, y, lb, tb, rb, bb);

			//then let's just assume the object isn't a solid to begin with...
			solid = false;
			
			//image stuff
			visible = true;
			frameCount = 0;
			currFrame = 0;
			currAniX=0;
			currAniY=0;
			
			image_sprite = new Sprite();
		}
		
		public function Render():void
		{
			if (!visible)
				return;
				
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			matrix.scale(Global.zoom, Global.zoom); 
			Game.Renderer.draw(image_sprite, matrix);
		}
		
		public function DrawSpriteFromSheet(temp_image:Bitmap, temp_sheet:Bitmap):void
		{
			for (var i:int = 0; i < image_sprite.numChildren;i++){
				image_sprite.removeChildAt(0);
			}
			
			var sprite_x:int = currFrame*frameWidth+currAniX*frameWidth;
			var sprite_y:int = currAniY*frameHeight;
			temp_image.bitmapData.copyPixels(temp_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, frameWidth, frameHeight), 
				new Point(0,0)
			);
			
			image_sprite.addChild(temp_image);
		}
		
		public function UpdateAnimation():void
		{
			if (++frameCount >= frameDelay)
			{
				if (++currFrame >= maxFrame) 
					currFrame = 0;
				frameCount = 0;
			}
		}
		
		public function CheckRectIntersect(obj2:GameObject, lb:int, 
			tb:int, rb:int, bb:int):Boolean
		{			
			if (lb <= (obj2.x + obj2.rb) && rb >= (obj2.x + obj2.lb) &&
				tb <= (obj2.y + obj2.bb) && bb >= (obj2.y + obj2.tb))
			{
				return true;
			}
			return false;
		}
	}
}