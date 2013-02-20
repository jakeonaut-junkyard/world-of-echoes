package Entities 
{
	import Entities.Parents.GameFaller;
	import LoaderManagers.VoiceManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class DeerDog extends GameFaller
	{
		//movement members
		public var top_xspeed:Number;
		public var jump_vel:Number;
		
		public var followingPlayer:Boolean;
		public var wanderTimer:int;
		public var runX:int;
		public var playedNote:Boolean;
		
		public var move_state:int;
		public var prev_move_state:int;
		public const STANDING:int = 0;
		public const RUNNING:int = 1;
		public const JUMPING:int = 2;
		public const FALLING:int = 3;
		
		private var _voice:VoiceManager;
		private var noteQueue:Array;
		
		[Embed(source = "../resources/images/deerDog_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function DeerDog(x:int, y:int) 
		{
			super(x, y, 4, 6, 12, 15);
			top_xspeed = 2.0;
			jump_vel = 8.50;
			terminal_vel = 6.5;
			grav_acc = 1.0;

			playedNote = false;
			wanderTimer = 0;
			runX = 0;
			followingPlayer = false;
			facing = Global.RIGHT;
			move_state = STANDING;
			prev_move_state = move_state;
			
			_voice = new VoiceManager();
			_voice.SetVoice(9, 1);
			noteQueue = [];
			
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
				followingPlayer = false;
				noteQueue = [];
				for (i = 0; i < 2; i++){
					noteQueue.push(i*10);
				}noteQueue.push(3);
			}
			
			for (i = noteQueue.length-1; i >= 0; i--){
				noteQueue[i]--;
				if (noteQueue[i] < 0){
					var rand:int = Math.floor(Math.random()*_voice.noteArray.length);
					Game._driver.noteOff(_voice.noteArray[rand]);
					Game._driver.noteOn(_voice.noteArray[rand], _voice.voice, 1);
					entities.push(new Burst(x-8, y-10, true));
					noteQueue.splice(i, 1);
					if (noteQueue.length <= 0) playedNote = false;
				}
			}
			for (i = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					if (followingPlayer) FollowPlayerRun(entities[i]);
					else WanderAndGetTagged(entities[i]);
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
		
		public function WanderAndGetTagged(avatar:Avatar):void
		{
			if (CheckRectIntersect(avatar, x+lb, y+tb, x+rb, y+bb)){
				followingPlayer = true;
				noteQueue = [];
				for (var i:int = 0; i < 4; i++){
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
		
		public function FollowPlayerJump():void
		{
			if (runX != 0 && vel.x == 0 || 
					(GameWorld.pInput.playedNote && followingPlayer)){
				
				if (on_ground || (GameWorld.pInput.playedNote && followingPlayer)
						|| (!playedNote && runX != 0 && vel.x == 0)){
					playedNote = true;
					if (noteQueue.length <= 0){
						noteQueue.push(0);
						noteQueue.push(5);
					}else{
						var base:int = noteQueue[0];
						noteQueue = [];
						for (var i:int = 0; i < 2; i++){
							noteQueue.push(base+5*i);
						}
					}
				}

				move_state = JUMPING;
				if (on_ground){
					on_ground = false;
					vel.y = -jump_vel;
				}else{
					vel.y = -jump_vel/2;
				}
			}
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