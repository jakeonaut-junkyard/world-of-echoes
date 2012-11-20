package Entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class VoiceOrbFade extends GameSprite
	{
		public var color:ColorTransform;
		private var myAlpha:Number;
		
		[Embed(source = "../resources/images/glow_orb.png")]
		private var sprite_sheet:Class;
		
		public function VoiceOrbFade(x:int, y:int, color:ColorTransform) 
		{
			super(x, y, 12, 12, 20, 20);
			
			//animation management creation
			myAlpha = 1;
			frameDelay = 2;
			maxFrame = 7;
			frameWidth = 32;
			frameHeight = 32;
			
			this.color = new ColorTransform();
			this.color.redMultiplier = color.redMultiplier;
			this.color.blueMultiplier = color.blueMultiplier;
			this.color.greenMultiplier = color.greenMultiplier;
		}
		
		override public function Render():void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			super.DrawSpriteFromSheet(temp_image, temp_sheet);
			
			//RENDER IT //CREATE ALPHA
			color.alphaMultiplier = myAlpha;
			
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			matrix.scale(Global.zoom, Global.zoom); 
			Game.Renderer.draw(image_sprite, matrix, color);
		}
		
		public function Update():void
		{				
			if (++frameCount >= frameDelay)
			{
				myAlpha -= 0.143;
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