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
	
	public class RedMonkey extends PlayerFollower
	{		
		public static const REDMONKEY_TRACKID:int = 2;
		public var breather:int;
		public var breatherMax:int;
		public var baseY:Number;
		
		[Embed(source = "../../resources/images/redMonkey_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function RedMonkey(x:int, y:int) 
		{
			super(x, y, 4, 6, 12, 15);
			breather = 0;
			breatherMax = 15;
			facing = Global.RIGHT;
			baseY = y;
			
			//_voice.SetVoice(2, 17);
			//_voice.SetVoice(12, 4);
			//_voice.SetVoice(14, 23);
			_voice.SetVoice(14, 8);
			//_voice.SetVoice(3, 17);
			
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
				if (noteQueue[i] <= 0){
					var rand:int = Math.floor(Math.random()*_voice.noteArray.length);
					Game._driver.noteOff(_voice.noteArray[rand], REDMONKEY_TRACKID);
					Game._driver.noteOn(_voice.noteArray[rand], _voice.voice, 1, 0, 0, REDMONKEY_TRACKID);
					entities.push(new Burst(x-8, y-10, true));
					noteQueue.splice(i, 1);
				}
			}
			for (i = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					baseY = entities[i].y;
					if (followingPlayer) FollowPlayerRun(entities[i]);
					else WanderAndGetTagged(entities[i], entities);
					break;
				}
			}
			Gravity();
			UpdateMovement(entities, map);
			PlayRhythms();
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
			if (runX != 0 && vel.x == 0 || (GameWorld.pInput.playedNote && followingPlayer)){
				if (GameWorld.pInput.playedNote && followingPlayer){
					breather = breatherMax;
					noteQueue = [];
					noteQueue.push(0);
					noteQueue.push(3*breatherMax/4);
				}
				move_state = JUMPING;
				if (on_ground){
					on_ground = false;
					if (y > baseY-32 || !followingPlayer) vel.y = -jump_vel;
				}else{
					if (y > baseY-32 || !followingPlayer) vel.y = -jump_vel/1.5;
				}
			}
		}
		
		public function PlayRhythms():void
		{
			if (runX != 0){
				breather--;
				if (breather <= 0 && noteQueue.length <= 0){
					breather = breatherMax;
					noteQueue = [];
					noteQueue.push(0);
				}
			}else breather = 0;
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