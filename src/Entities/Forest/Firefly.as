package Entities.Forest 
{
	import Entities.Avatar;
	import Entities.Parents.GameMover;
	import LoaderManagers.SoundManager;
	import flash.utils.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Firefly extends GameMover
	{
		[Embed(source = "../../resources/images/firefly_sheet.png")]
		private var my_sprite_sheet:Class;
		
		private var myAlpha:Number;
		private var alphaAdder:Number;
		private var lifeCounter:int;
		
		private var xvel:Number;
		private var yvel:Number;
		private var moveCounterX:int;
		private var moveCounterY:int;
		
		public function Firefly(x:int, y:int)
		{
			super(x, y, 3, 0, 7, 10);
			
			myAlpha = 0.2;
			alphaAdder = 0.1;
			lifeCounter = 0;
			
			isDisposable = true;
			moveCounterX = 4;
			moveCounterY = 3;
			facing = Global.RIGHT;
			xvel = (1-Math.floor(Math.random()*3))*0.5;
			yvel = (1-Math.floor(Math.random()*3))*0.5;
			if (xvel < 0) facing = Global.LEFT;
			
			sprite_sheet = my_sprite_sheet;
			frameWidth = 16;
			frameHeight = 16;
			frameDelay = 3;
			maxFrame = 1;
			currAniY = Math.floor(Math.random()*2);
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
			if (delete_me) return;
			
			if (alphaAdder > 0){
				myAlpha+=alphaAdder;
				if (myAlpha >= 1){
					alphaAdder *= -1;
				}
			}else{
				myAlpha+=alphaAdder;
				if (myAlpha <= 0){
					lifeCounter++;
					if (Math.floor(Math.random()*3) > 0 || lifeCounter >= 4)
						delete_me = true;
					alphaAdder *= -1;
				}
			}
			UpdateMoveTimerMove();
			UpdateAnimation();
		}
		
		public function UpdateMoveTimerMove():void
		{
			moveCounterX-=Global.CURR_PHYSICS_SPEED;
			moveCounterY-=Global.CURR_PHYSICS_SPEED;
			if (moveCounterX <= 0){
				xvel += (1-Math.floor(Math.random()*3))*0.5;
				if (xvel > 3) xvel = 3;
				if (xvel < -3) xvel = -3;
				
				moveCounterX = 6;
			}
			if (moveCounterY <= 0){
				yvel += (1-Math.floor(Math.random()*3))*0.5;
				if (yvel > 3) yvel = 3;
				if (yvel < -3) yvel = -3;
				
				moveCounterY = 5;
			}
			
			x+=xvel;
			y+=yvel;
		}
	}
}