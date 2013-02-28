package LoaderManagers
{
	import Entities.Avatar;
	import Entities.Burst;
	
	public class PlayerInputManager 
	{
		public static const AVATAR_TRACKID:int = 0;
		public var currWingFlaps:int
		public var lastNote:String;
		public var playedNote:Boolean;
		
		public var _voice:VoiceManager;
		
		public function PlayerInputManager() 
		{
			_voice = new VoiceManager();
			_voice.SetVoice(16, 52);
			//_voice.SetVoice(0, 13);
			
			currWingFlaps = 0;
			lastNote = "";
			playedNote = false;
		}
		
		public function PlayerInput(entities:Array, pIndex:int):void
		{
			_voice.TranslateNoteArray(Game._SiONArray);
			if (Global.CheckKeyPressed(Global.Z_KEY))
				SoundManager.getInstance().playSfx("InsectSound", 0, 1);
			playedNote = false;
			PlayerJump(entities[pIndex], entities);
			PlayerRun(entities[pIndex]);
		}
		
		private function PlayerJump(avatar:Avatar, entities:Array):void
		{
			//CONTROL AVATAR JUMPING
			if (Global.CheckKeyPressed(Global.X_KEY) || avatar.inputJump){
				if (currWingFlaps < Global.MAX_WINGFLAPS){
					avatar.inputJump = false;
					avatar.vel.y = -avatar.jump_vel;
					if (!avatar.on_ground) avatar.vel.y/=1.5;
					avatar.on_ground = false;
					
					entities.push(new Burst(avatar.x-16, avatar.y-20));
					currWingFlaps++;
					
					playedNote = true;
					var rand:int = Math.floor(Math.random()*_voice.noteArray.length);
					Game._driver.noteOff(_voice.noteArray[rand], AVATAR_TRACKID);
					Game._driver.noteOn(_voice.noteArray[rand], _voice.voice, 4, 0, 0, AVATAR_TRACKID);
				}
			}
			if (avatar.hit_head == 0){
				if (Global.CheckKeyDown(Global.X_KEY) && !avatar.on_ground){
					if (avatar.vel.y > 0) avatar.vel.y = 1;
				}
			}
			else if (avatar.hit_head >= 2){ 
				avatar.y += 2;
				avatar.vel.y = 0;
			}
			
			if (avatar.on_ground) currWingFlaps = 0;
		}
		
		private function PlayerRun(avatar:Avatar):void
		{
			//CONTROL AVATAR RUNNING
			var speed:Number = avatar.top_xspeed;
			if (!avatar.on_ground && !playedNote) speed/=10;
			
			if (Global.CheckKeyDown(Global.RIGHT)){
				avatar.vel.x += speed;
				if (avatar.vel.x > avatar.top_xspeed) 
					avatar.vel.x = avatar.top_xspeed;
				avatar.facing = Global.RIGHT;
				if (avatar.on_ground)
					avatar.move_state = avatar.RUNNING;
			}else if (Global.CheckKeyDown(Global.LEFT)){
				avatar.vel.x -= speed;
				if (avatar.vel.x < -avatar.top_xspeed) 
					avatar.vel.x = -avatar.top_xspeed;
				avatar.facing = Global.LEFT;
				if (avatar.on_ground)
					avatar.move_state = avatar.RUNNING;
			}else{
				if (avatar.on_ground){
					avatar.vel.x = 0;
					avatar.move_state = avatar.STANDING;
				}
			}
		}
	}
}