package Entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import Global;
	
	public class Avatar extends GameFaller
	{
		//movement members
		public var top_xspeed:Number;
		public var jump_vel:Number;
		public var facing:int;
		
		public var move_state:int;
		public var prev_move_state:int;
		public const STANDING:int = 0;
		public const RUNNING:int = 1;
		public const JUMPING:int = 2;
		public const FALLING:int = 3;
		
		[Embed(source = "../resources/images/avatar.png")]
		private var sprite_sheet:Class;
		
		public function Avatar(x:int, y:int) 
		{
			super(x, y, 9, 9, 15, 24);
			top_xspeed = 3.5;
			jump_vel = 8.33;
			terminal_vel = 5.0;
			grav_acc = 1.0;

			facing = Global.RIGHT;
			move_state = STANDING;
			prev_move_state = move_state;
			
			//animation management creation
			frameDelay = 5;
			maxFrame = 1;
			frameWidth = 24;
			frameHeight = 24;
		}	
		
		override public function Render():void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			super.DrawSpriteFromSheet(temp_image, temp_sheet);
			
			//RENDER IT
			var matrix:Matrix = new Matrix();
			if (facing == Global.LEFT)
			{
				matrix.scale(-1, 1);
				matrix.translate(frameWidth, 0);
			}
			matrix.translate(x, y);
			matrix.scale(Global.zoom, Global.zoom);
			
			Game.Renderer.draw(image_sprite, matrix);
		}
		
		public function Update(solids:Array):void
		{
			Gravity();
			UpdateMovement(solids);
			
			UpdateAnimation();
		}
		
		override public function UpdateAnimation():void
		{
			//DETERMINE AIRBORNE MOVEMENT STATE
			if (!on_ground)
			{
				if (vel.y < 0)
					move_state = JUMPING;
				else
					move_state = FALLING;
			}
			
			//house keeping (kind of)
			if (prev_move_state != move_state)
			{
				currFrame = 0;
				frameCount = 0;
			}
			prev_move_state = move_state;
			
			//UPDATE ANIMATION (DEPENDING ON MOVEMENT STATE)			
			switch(move_state)
			{
				case STANDING:
					currAniX = 0;
					currAniY = 0;
					maxFrame = 1;
					break;
				case RUNNING:
					currAniX = 0;
					currAniY = 1;
					maxFrame = 4;
					break;
				case JUMPING:
					currAniX = 0;
					currAniY = 2;
					maxFrame = 1;
					break;
				case FALLING:
					currAniX = 1;
					currAniY = 2;
					maxFrame = 1;
					break;
			}
			
			super.UpdateAnimation();
		}
	}
}