package Entities 
{
	import Entities.Avatar;
	import Entities.Parents.GameMover;
	import LoaderManagers.SoundManager;
	import flash.utils.*;
	
	public class GoldWorm extends GameMover
	{
		[Embed(source = "../resources/images/gold_worm_sheet.png")]
		private var my_sprite_sheet:Class;
		private var twinkle:int;
		
		private var base_x:int;
		private var base_y:int;
		private var xvel:Number;
		private var yvel:Number;
		private var moveCounterX:int;
		private var moveCounterY:int;
		
		public function GoldWorm(x:int, y:int)
		{
			super(x, y, 3, 0, 7, 10);
			
			base_x = x;
			base_y = y;
			moveCounterX = 4;
			moveCounterY = 3;
			facing = Global.RIGHT;
			xvel = (1-Math.floor(Math.random()*3));
			yvel = (1-Math.floor(Math.random()*3));
			if (xvel < 0) facing = Global.LEFT;
			
			sprite_sheet = my_sprite_sheet;
			frameWidth = 16;
			frameHeight = 16;
			frameDelay = 3;
			maxFrame = 2;
			twinkle = 5+Math.floor(Math.random()*10);
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{
			if (delete_me) return;
			
			var avatar:Avatar = null;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					avatar = entities[i];
					if (CheckRectIntersect(avatar, x+lb, y+tb, x+rb, y+bb)){
						SoundManager.getInstance().playSfx("InsectSound", 0, 1);
						avatar.inputJump = true;
						delete_me = true;
						visible = true;
						Global.MAX_WINGFLAPS++;
					}
					break;
				}
			}
			
			if (avatar == null) return;
			var avatar_distance:int = Math.abs((x+rb/2)-(avatar.x+avatar.rb/2));
			if (avatar_distance >= 300) return;
			UpdateMoveTimerMove();
			
			twinkle--;
			if (twinkle <= 0){
				var rx:int = Math.floor(Math.random()*(rb+6))-3;
				var ry:int = Math.floor(Math.random()*(bb+6))-3;
				entities.push(new GoldTwinkle(x+rx, y+ry));
				twinkle = 5+Math.floor(Math.random()*10);
			}
			
			UpdateAnimation();
		}
		
		public function UpdateMoveTimerMove():void
		{
			moveCounterX-=Global.CURR_PHYSICS_SPEED;
			moveCounterY-=Global.CURR_PHYSICS_SPEED;
			if (moveCounterX <= 0){
				xvel = (1-Math.floor(Math.random()*3))*0.5;
				if (x >= base_x+4) xvel = -0.5;
				else if (x <= base_x-4) xvel = 0.5;
				
				moveCounterX = 6;
			}
			if (moveCounterY <= 0){
				yvel = (1-Math.floor(Math.random()*3))*0.5;
				if (y >= base_y+4) yvel = -0.5;
				else if (y <= base_y-4) yvel = 0.5;
				
				moveCounterY = 5;
			}
			
			x+=xvel;
			y+=yvel;
		}
	}
}