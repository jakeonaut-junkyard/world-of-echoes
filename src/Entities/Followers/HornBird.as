package Entities.Followers 
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.Parents.PlayerFollower;
	import LoaderManagers.VoiceManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class HornBird extends PlayerFollower
	{		
		public static const HORNBIRD_TRACKID:int = 3;
		public var playedNote:Boolean;
		public var baseY:Number;
		public var noteWanderTimer:int;
		
		[Embed(source = "../../resources/images/hornBird_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function HornBird(x:int, y:int) 
		{
			super(x, y, 4, 6, 12, 24);
			playedNote = false;
			baseY = 480;
			
			noteWanderTimer = Math.floor(Math.random()*25)+40;
			facing = Global.RIGHT;
			terminal_vel = 6.5/2;
			grav_acc = 1.0/2;
			jump_vel = 8.50/2.5;
			
			//_voice.SetVoice(5, 12);
			//_voice.SetVoice(10, 11);
			_voice.SetVoice(3, 4);
			
			//animation management creation
			sprite_sheet = my_sprite_sheet;
			frameDelay = 7;
			maxFrame = 3;
			frameWidth = 16;
			frameHeight = 16;
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{	
			var i:int;
			_voice.TranslateNoteArray(Game._SiONArray);
			if (Global.CheckKeyPressed(Global.Z_KEY) && followingPlayer){
				StopFollowingPlayer();
			}
			
			for (i = noteQueue.length-1; i >= 0; i--){
				noteQueue[i]--;
				if (noteQueue[i] < 0){
					var rand:int = Math.floor(Math.random()*_voice.noteArray.length);
					Game._driver.noteOff(_voice.noteArray[rand], HORNBIRD_TRACKID);
					Game._driver.noteOn(_voice.noteArray[rand], _voice.voice, 4, 0, 0, HORNBIRD_TRACKID);
					entities.push(new Burst(x-8, y-10, true));
					noteQueue.splice(i, 1);
					if (noteQueue.length <= 0) playedNote = false;
				}
			}
			for (i = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					if (followingPlayer){
						baseY = entities[i].y;
						FollowPlayerRun(entities[i]);
					}
					else WanderAndGetTagged(entities[i], entities);
					break;
				}
			}
			Gravity();
			UpdateMovement(entities, map);
			FollowPlayerJump();
			
			if (!on_ground && hit_head){
				y+=3;
			}

			UpdateAnimation();
		}
		
		public function FollowPlayerRun(avatar:Avatar):void
		{
			var speed:Number = top_xspeed;
			if (avatar.x > x+rb+16 || avatar.x+avatar.rb < x-16)
				speed *= 1.5;
			
			if (avatar.x > x+rb+8){
				vel.x = speed;
				move_state = RUNNING;
				runX = 1;
			}else if (avatar.x+avatar.rb < x-8){
				vel.x = -speed;
				move_state = RUNNING;
				runX = -1;
			}else{
				vel.x = 0;
				move_state = STANDING;
				runX = 0;
			}
			
			if (avatar.x > x+rb) facing = Global.RIGHT;
			else if (avatar.x+avatar.rb < x) facing = Global.LEFT;
		}
		
		public function FollowPlayerJump():void
		{
			if (baseY < y){
				vel.y = -jump_vel/2;
			}
			
			if (runX != 0 && vel.x == 0 || 
					(GameWorld.pInput.playedNote && followingPlayer)){
				
				if (GameWorld.pInput.playedNote && followingPlayer){
					playedNote = true;
					if (noteQueue.length <= 0){
						noteQueue.push(5);
					}else{
						var base:int = noteQueue[0];
						noteQueue = [];
						for (var i:int = 1; i < 2; i++){
							noteQueue.push(base+5*i);
						}
					}
				}

				move_state = JUMPING;
				if (y > baseY-32) vel.y = -jump_vel;
				if (on_ground) on_ground = false;
			}
		}
		
		override public function WanderAndGetTagged(avatar:Avatar, entities:Array):void
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
				noteQueue.push(0);
				noteQueue.push(5);
			}
			
			if (on_ground) baseY = y;
			wanderTimer--;
			noteWanderTimer--;
			if (noteWanderTimer <= 0){
				noteQueue = [];
				noteQueue.push(10+Math.floor(Math.random()*10));
				noteWanderTimer = Math.floor(Math.random()*25)+40;
			}
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
		
		override public function StopFollowingPlayer():void
		{
			noChaseTimer = 30;
			followingPlayer = false;
			noteWanderTimer = Math.floor(Math.random()*25)+40;
			noteQueue = [];
			noteQueue.push(0);
			noteQueue.push(5);
		}
		
		override public function UpdateAnimation():void
		{
			if (vel.x > 0) facing = Global.RIGHT;
			else if (vel.x < 0) facing = Global.LEFT;
			
			//DETERMINE AIRBORNE MOVEMENT STATE
			if (!on_ground){
				if (vel.y < 0)
					move_state = JUMPING;
				else
					move_state = FALLING;
			}
			
			//house keeping (kind of)
			if (prev_move_state != move_state){
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
					frameDelay = 7;
					break;
				case RUNNING:
					currAniX = 0;
					currAniY = 1;
					frameDelay = 4;
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