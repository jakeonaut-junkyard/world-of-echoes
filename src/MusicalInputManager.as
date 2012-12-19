package  
{
	import Entities.Avatar;
	import org.si.sion.SiONDriver;
	import org.si.sion.sequencer.SiMMLTrack;
	
	public class MusicalInputManager 
	{
		private var asdfjklKeys:Array;
		private var asdfjklKeyCounters:Array;
		
		private var trackId:int = Global.AVATAR_VOICE_ID;
		
		private var justJumped:int = 0;
		private var doubleJumped:Boolean = false;
		private var stopRunCounter:int;
		private var runDir:int;
		private const LEFT:int = 0;
		private const RIGHT:int = 1;
		
		public function MusicalInputManager() 
		{			
			asdfjklKeys = [false, false, false, false, false, false, false, false];
			asdfjklKeyCounters = [0, 0, 0, 0, 0, 0, 0, 0];
			stopRunCounter = 0;
		}
		
		public function Update(avatar:Avatar, scale:Array):void
		{
			UpdateKeyArray();
			var noteLength:int = 15;
			//play the notes
			for (var i:int = 0; i < asdfjklKeys.length; i++)
			{
				if (asdfjklKeyCounters[i] == 3)
				{
					Game._driver.noteOff(avatar._voice.noteArray[i], trackId, 0, 0, true);
					Game._driver.noteOn(avatar._voice.noteArray[i], avatar._voice.voice, 4, 0, 0, trackId);
					
					if (i <= 3) i = 3;
					else break;
				}
			}
			
			PlayerJump(avatar);
			PlayerRun(avatar);
			
			//DEBUG:: Create new instrument
			if (Global.CheckKeyPressed(Global.ENTER))
			{
				avatar._voice.CreateRandomInstrument(scale);
			}
		}
		
		private function PlayerRun(avatar:Avatar):void
		{
			//move the player //LEFT
			var i:int;
			var move:Boolean = false;
			if (!Global.CheckKeyDown(Global.DOWN))
			{
				for (i = 0; i < 4; i++){
					if (asdfjklKeys[i]){
						move = true;
						break;
					}
				}
			}
			if (move || Global.CheckKeyDown(Global.LEFT)){
				if (runDir == LEFT || stopRunCounter < 3 || Global.CheckKeyDown(Global.LEFT))
				{
					avatar.vel.x = -avatar.top_xspeed;
					avatar.facing = Global.LEFT;
					stopRunCounter = 10;
					runDir = LEFT;
					
					if (avatar.on_ground)
						avatar.move_state = avatar.RUNNING;
				}
			}
			
			//move the player //RIGHT
			move = false;
			if (!Global.CheckKeyDown(Global.DOWN))
			{
				for (i = 4; i < 8; i++){
					if (asdfjklKeys[i]){
						move = true;
						break;
					}
				}
			}
			if (move || Global.CheckKeyDown(Global.RIGHT)){
				if (runDir == RIGHT || stopRunCounter < 3 || Global.CheckKeyDown(Global.RIGHT))
				{
					avatar.vel.x = avatar.top_xspeed;
					avatar.facing = Global.RIGHT;
					stopRunCounter = 10;
					runDir = RIGHT;
					
					if (avatar.on_ground)
						avatar.move_state = avatar.RUNNING;
				}
			}
			
			//STOP MOVEMENT
			if (Global.CheckKeyDown(Global.LEFT) || Global.CheckKeyDown(Global.RIGHT))
				stopRunCounter = 0;
			else
				stopRunCounter--;
			if (stopRunCounter <= 0){
				stopRunCounter = 0;
				
				if (!Global.CheckKeyDown(Global.LEFT) && !Global.CheckKeyDown(Global.RIGHT))
				{
					avatar.vel.x = 0;
					if (avatar.on_ground)
						avatar.move_state = avatar.STANDING;
				}
			}
		}
		
		private function PlayerJump(avatar:Avatar):void
		{
			//JUMPING
			if (justJumped <= 0 && !doubleJumped)
			{
				var lcounter:int = 0;
				var rcounter:int = 0;
				var i:int;
				for (i = 0; i < asdfjklKeyCounters.length; i++)
				{
					if (asdfjklKeyCounters[i] > 0)
					{
						if (i <= 3)
							lcounter++;
						else	
							rcounter++;
					}
				}
				if (lcounter >= 3 || rcounter >= 3 || Global.CheckKeyPressed(Global.UP)) 
				{
					justJumped = 5;
					if (!avatar.on_ground) doubleJumped = true;
					avatar.on_ground = false;
					avatar.vel.y = -avatar.jump_vel;
				}
			}
			else justJumped--;
			
			if (avatar.hit_head == 0)
			{
				if ((stopRunCounter > 0 || Global.CheckKeyDown(Global.UP)) && !avatar.on_ground)
				{
					avatar.y-=2;
					if (avatar.vel.y > 0)
						avatar.y-=1;
				}
				
			}
			else if (avatar.hit_head >= 2) avatar.y+=2;
			
			if (avatar.on_ground && doubleJumped) doubleJumped = false;
		}
		
		public function PlayedANote():Boolean
		{
			for (var i:int = 0; i < asdfjklKeyCounters.length; i++)
			{
				if (asdfjklKeyCounters[i] == 3) return true;
			}
			return false;
		}
		
		private function UpdateKeyArray():void
		{
			for (var i:int = 0; i < asdfjklKeyCounters.length; i++)
			{
				asdfjklKeyCounters[i]--;
			}
			
			if (Global.CheckKeyPressed(Global.A_KEY)){
				asdfjklKeys[0] = true;
				asdfjklKeyCounters[0] = 3;
			}else asdfjklKeys[0] = false;
			
			if (Global.CheckKeyPressed(Global.S_KEY)){
				asdfjklKeys[1] = true;
				asdfjklKeyCounters[1] = 3;
			}else asdfjklKeys[1] = false;
			
			if (Global.CheckKeyPressed(Global.D_KEY)){
				asdfjklKeys[2] = true;
				asdfjklKeyCounters[2] = 3;
			}else asdfjklKeys[2] = false;
			
			if (Global.CheckKeyPressed(Global.F_KEY)){
				asdfjklKeys[3] = true;
				asdfjklKeyCounters[3] = 3;
			}else asdfjklKeys[3] = false;
			
			if (Global.CheckKeyPressed(Global.J_KEY) || Global.CheckKeyPressed(Global.Q_KEY)){
				asdfjklKeys[4] = true;
				asdfjklKeyCounters[4] = 3;
			}else asdfjklKeys[4] = false;
			
			if (Global.CheckKeyPressed(Global.K_KEY) || Global.CheckKeyPressed(Global.W_KEY)){
				asdfjklKeys[5] = true;
				asdfjklKeyCounters[5] = 3;
			}else asdfjklKeys[5] = false;
			
			if (Global.CheckKeyPressed(Global.L_KEY) || Global.CheckKeyPressed(Global.E_KEY)){
				asdfjklKeys[6] = true;
				asdfjklKeyCounters[6] = 3;
			}else asdfjklKeys[6] = false;
			
			if (Global.CheckKeyPressed(Global.SEMICOLON) || Global.CheckKeyPressed(Global.R_KEY)){
				asdfjklKeys[7] = true;
				asdfjklKeyCounters[7] = 3;
			}else asdfjklKeys[7] = false;
		}
	}
}