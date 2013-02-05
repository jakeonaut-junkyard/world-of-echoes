package Entities 
{
	import Entities.Parents.GameFaller;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Avatar extends GameFaller
	{
		//movement members
		public var top_xspeed:Number;
		public var jump_vel:Number;
		
		public var inputJump:Boolean = false;
		private var doubleJump:Boolean = false;
		public var float:Boolean = false;
		
		public var move_state:int;
		public var prev_move_state:int;
		public const STANDING:int = 0;
		public const RUNNING:int = 1;
		public const JUMPING:int = 2;
		public const FALLING:int = 3;
		
		public var trackId:int;
		
		[Embed(source = "../resources/images/avatar_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function Avatar(x:int, y:int, trackId:int) 
		{
			super(x, y, 4, 2, 12, 16);
			top_xspeed = 2.0;
			jump_vel = 8.50;
			terminal_vel = 6.5;
			grav_acc = 1.0;

			facing = Global.RIGHT;
			move_state = STANDING;
			prev_move_state = move_state;
			
			this.trackId = trackId;
			
			//animation management creation
			sprite_sheet = my_sprite_sheet;
			frameDelay = 5;
			maxFrame = 4;
			frameWidth = 16;
			frameHeight = 16;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			if (inputJump && on_ground){
				vel.y = -jump_vel;
				on_ground = false;
			}
			inputJump = false;
			
			Gravity();
			UpdateMovement(entities, map);
			
			if (!on_ground)
			{
				if (float && !hit_head){
					y-=(2*Global.CURR_PHYSICS_SPEED);
					if (vel.y > 0)
						y-=Global.CURR_PHYSICS_SPEED;
				}
				else if (hit_head)
					y+=(3);
			}

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
					break;
				case RUNNING:
					currAniX = 0;
					currAniY = 1;
					break;
				case JUMPING:
					currAniX = 0;
					currAniY = 2;
					break;
				case FALLING:
					currAniX = 0;
					currAniY = 3;
					break;
			}
			
			super.UpdateAnimation();
		}
	}
}