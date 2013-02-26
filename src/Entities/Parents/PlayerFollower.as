package Entities.Parents 
{
	import Entities.Avatar;
	import Entities.Parents.GameFaller;
	import LoaderManagers.VoiceManager;
	import flash.utils.*;
	
	public class PlayerFollower extends GameFaller
	{		
		protected var _voice:VoiceManager;
		protected var noteQueue:Array;
		
		public var followingPlayer:Boolean;
		public var noChaseTimer:int;
		public var wanderTimer:int;
		public var runX:int;
		
		//movement members
		public var top_xspeed:Number;
		public var jump_vel:Number;
		
		public var move_state:int;
		public var prev_move_state:int;
		public const STANDING:int = 0;
		public const RUNNING:int = 1;
		public const JUMPING:int = 2;
		public const FALLING:int = 3;
		
		public function PlayerFollower(x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			_voice = new VoiceManager();
			noteQueue = [];
			
			followingPlayer = false;
			noChaseTimer = 0;
			wanderTimer = 0;
			runX = 0;
			
			top_xspeed = 2.0;
			jump_vel = 8.50;
			terminal_vel = 6.5;
			grav_acc = 1.0;
			move_state = STANDING;
			prev_move_state = move_state;
		}
		
		public function WanderAndGetTagged(avatar:Avatar, entities:Array):void
		{
			var i:int;
			if (noChaseTimer > 0) noChaseTimer--;
			if (CheckRectIntersect(avatar, x+lb, y+tb, x+rb, y+bb) && noChaseTimer <= 0){
				for (i = 0; i < entities.length; i++){
					if (entities[i] is PlayerFollower && entities[i].followingPlayer){
						entities[i].StopFollowingPlayer();
					}
				}
				followingPlayer = true;
				noteQueue = [];
				for (i = 0; i < 4; i++){
					noteQueue.push(i*3);
				}
			}
				
			wanderTimer--;
			if (wanderTimer <= 0){
				wanderTimer = Math.floor(Math.random()*25)+20;
				var rand:int = Math.floor(Math.random()*3);
				if (rand > 0)
					runX = Math.floor(Math.random()*3)-1;
				else runX = 0;
			}
			if (runX != 0) vel.x = runX*(top_xspeed/2);
			else vel.x = 0;
			
			if (vel.x == 0) move_state = STANDING;
			else move_state = RUNNING;
		}
		
		public function StopFollowingPlayer():void
		{
			noChaseTimer = 30;
			followingPlayer = false;
			noteQueue = [];
			for (var i:int = 0; i < 2; i++){
				noteQueue.push(i*10);
			}noteQueue.push(3);
		}
	}
}