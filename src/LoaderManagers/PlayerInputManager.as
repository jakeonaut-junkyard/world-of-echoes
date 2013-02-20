package LoaderManagers
{
	import Entities.Avatar;
	import Entities.Burst;
	
	public class PlayerInputManager 
	{
		public var trackId:int;
		public var currWingFlaps:int
		public var lastNote:String;
		public var playedNote:Boolean;
		
		public var chordPlay:int;
		public var chordIndex:int;
		
		public function PlayerInputManager() 
		{
			trackId = 0;
			currWingFlaps = 0;
			lastNote = "";
			playedNote = false;
			chordPlay = 0;
			chordIndex = 0;
		}
		
		public function PlayerInput(entities:Array, pIndex:int):void
		{
			if (Global.CheckKeyPressed(Global.Z_KEY))
				SoundManager.getInstance().playSfx("InsectSound", 0, 1);
			playedNote = false;
			PlayerJump(entities[pIndex], entities);
			PlayerRun(entities[pIndex]);
			if (chordPlay > 0) PlayChords(entities[pIndex], entities);
		}
		
		private function PlayChords(avatar:Avatar, entities:Array):void
		{
			if (chordPlay%2==0){
				var note:String = Game._noteArray[chordIndex];
				if (note == lastNote){
					chordIndex++; 
					if (chordIndex >= Game._noteArray.length) 
						chordIndex = 0;
					note = Game._noteArray[chordIndex];
				}lastNote = note;
				
				entities.push(new Burst(avatar.x-16, avatar.y-8));
				//SoundManager.getInstance().stopSfx(note);
				SoundManager.getInstance().playSfx(note, 0, 1);
				chordIndex++;
			}
			chordPlay--;
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
					
					var index:int = Math.floor(Math.random()*Game._noteArray.length);
					var note:String = Game._noteArray[index];
					if (note == lastNote){
						index++; 
						if (index >= Game._noteArray.length) 
							index = 0;
						note = Game._noteArray[index];
					}lastNote = note;
					playedNote = true;
					if (currWingFlaps == Global.MAX_WINGFLAPS){
						chordPlay = 6;
						chordIndex = index;
					}else{
						SoundManager.getInstance().playSfx(note, 0, 1);
					}
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