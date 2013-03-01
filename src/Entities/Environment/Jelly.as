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
	
	public class Jelly extends GameMover
	{
		[Embed(source = "../../resources/images/jelly_sheet.png")]
		private var my_sprite_sheet:Class;
		protected var myAlpha:Number;
		protected var alphaAdder:Number;
		protected var alphaTimer:int;
		
		protected var moveTimer:int;
		protected var negYVel:int;
		
		public function Jelly(x:int, y:int)
		{
			super(x, y, 0, 0, 48, 48);
			sprite_sheet = my_sprite_sheet;
			
			myAlpha = 0.6+(Math.floor(Math.random()*5)*0.1);
			alphaAdder = -0.025;
			alphaTimer = 0;
			moveTimer = 0;
			negYVel = 1;
			if (Math.floor(Math.random()*2) <= 0)
				negYVel = -1;
			
			currAniY = Math.floor(Math.random()*2);
			topDownSolid = true;
			isDisposable = true;
			frameWidth = 48;
			frameHeight = 48;
			maxFrame = 2;
			frameDelay = 5;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();

			super.DrawSpriteFromSheet(temp_image, temp_sheet);

			//RENDER IT //CREATE ALPHA
			var color:ColorTransform = new ColorTransform();
			color.alphaMultiplier = myAlpha;

			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, color);
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{
			vel.y = (moveTimer/30)*2*(negYVel);
			x += vel.x;
			y += vel.y;
			
			moveTimer--;
			if (moveTimer <= 0){
				negYVel *= -1;
				moveTimer = 30;
			}
			
			alphaTimer--;
			if (alphaTimer <= 0){
				myAlpha += alphaAdder;
				if (myAlpha >= 0.9){
					alphaAdder = -0.025;
					alphaTimer = Math.floor(Math.random()*5)+5;
				}
				else if (myAlpha <= 0.6){
					alphaAdder = 0.025;
					alphaTimer = Math.floor(Math.random()*5)+5;
				}
			}
			UpdateAnimation();
		}
	}
}