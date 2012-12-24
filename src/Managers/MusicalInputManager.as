package Managers
{
	import Entities.Avatar;
	import org.si.sion.SiONDriver;
	import org.si.sion.sequencer.SiMMLTrack;
	
	public class MusicalInputManager 
	{
		private var asdfjklKeyCounters:Array;
		private var noteArray:Array;
		private var tempNoteFadeArray:Array;
		private var _decay:int = 5;
		
		private var trackId:int = Global.AVATAR_VOICE_ID;
		public var updateWorldScale:Boolean = false;
		public var rootNote:int = 12;
		
		private var justJumped:int = 0;
		private var doubleJumped:Boolean = false;
		private var stopRunCounter:Number;
		private var runDir:int;
		private const LEFT:int = 0;
		private const RIGHT:int = 1;
		
		public function MusicalInputManager() 
		{			
			asdfjklKeyCounters = [0, 0, 0, 0, 0, 0, 0, 0];
			noteArray = [];
			tempNoteFadeArray = [];
			stopRunCounter = 0;
		}
		
		public function Update(avatar:Avatar, scale:Array):void
		{
			UpdateManagerArrays(avatar);
			UpdatePlayNotes(avatar);			
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
					if (asdfjklKeyCounters[i] == 3){
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
					if (asdfjklKeyCounters[i] == 3){
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
			var decrement:Number = 1;
			if (Global.CheckKeyDown(Global.SPACE)) decrement = decrement / Global.DELAY_AMOUNT;
			if (Global.CheckKeyDown(Global.LEFT) || Global.CheckKeyDown(Global.RIGHT))
				stopRunCounter = 0;
			else
				stopRunCounter-=decrement;
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
					avatar.inputJump = true;
					
					updateWorldScale = true;
					if (lcounter >= 3)
						rootNote = (noteArray[0]%12)+12;
					else if (lcounter < 3)
						rootNote = (noteArray[4]%12)+12;
				}
			}
			else justJumped--;
			
			if (avatar.hit_head == 0)
			{
				if ((stopRunCounter > 0 || Global.CheckKeyDown(Global.UP)) && !avatar.on_ground)
				{
					avatar.float = true;
				}
				else
					avatar.float = false;
			}
			
			if (avatar.on_ground && doubleJumped) doubleJumped = false;
		}
		
		public function PlayNoteFromArray(avatar:Avatar, index:int):void
		{
			Game._driver.noteOff(noteArray[index]);
			RemoveFromFadeArray(noteArray[index]);
			
			var track:SiMMLTrack = Game._driver.noteOn(noteArray[index], avatar._voice.voice, 0);
		}
		
		public function StopNoteFromArray(index:int, delay:int = 0):void
		{
			if (delay == 0)
			{
				Game._driver.noteOff(noteArray[index]);
				RemoveFromFadeArray(noteArray[index]);
			}
			else
			{
				if (tempNoteFadeArray.length >= 6)
				{
					Game._driver.noteOff(tempNoteFadeArray[0][0]);
					tempNoteFadeArray.splice(0, 1);
				}
				tempNoteFadeArray.push([noteArray[index], delay]);
			}
		}
		
		public function StopAllNotes(delay:int = 0):void
		{
			var i:int;
			for (i = 0; i < noteArray.length; i++)
			{
				StopNoteFromArray(i, delay);
			}
			for (i = tempNoteFadeArray.length-1; i >= 0; i--)
			{
				Game._driver.noteOff(tempNoteFadeArray[i][0]);
				tempNoteFadeArray.splice(i, 1);
			}
		}
		
		public function RemoveFromFadeArray(index:int):void
		{
			for (var i:int = 0; i < tempNoteFadeArray.length; i++)
			{
				if (tempNoteFadeArray[i][0] == index)
				{
					tempNoteFadeArray.splice(i, 1);
					break;
				}
			}
		}
		
		private function UpdateManagerArrays(avatar:Avatar):void
		{
			if (noteArray != avatar._voice.noteArray)
			{
				noteArray = avatar._voice.noteArray;
			}
			
			var i:int;
			for (i = 0; i < asdfjklKeyCounters.length; i++)
			{
				if (asdfjklKeyCounters[i] > 0)
					asdfjklKeyCounters[i]--;
			}
			for (i = tempNoteFadeArray.length-1; i >= 0; i--)
			{
				tempNoteFadeArray[i][1]--;
				if (tempNoteFadeArray[i][1]<=0)
				{
					Game._driver.noteOff(tempNoteFadeArray[i][0]);
					tempNoteFadeArray.splice(i, 1);
				}	
			}
		}
		
		private function UpdatePlayNotes(avatar:Avatar):void
		{	
			if (Global.CheckKeyDown(Global.SPACE))
				_decay = 100;
			else if (Global.CheckKeyUp(Global.SPACE))
			{
				_decay = 5;
				StopAllNotes();
			}
			
			if (Global.CheckKeyPressed(Global.A_KEY)){
				asdfjklKeyCounters[0] = 3;
				PlayNoteFromArray(avatar, 0);
				StopNoteFromArray(0, _decay);
			}	
			
			if (Global.CheckKeyPressed(Global.S_KEY)){
				asdfjklKeyCounters[1] = 3;
				PlayNoteFromArray(avatar, 1);
				StopNoteFromArray(1, _decay);
			}
			
			if (Global.CheckKeyPressed(Global.D_KEY)){
				asdfjklKeyCounters[2] = 3;
				PlayNoteFromArray(avatar, 2);
				StopNoteFromArray(2, _decay);
			}
			
			if (Global.CheckKeyPressed(Global.F_KEY)){
				asdfjklKeyCounters[3] = 3;
				PlayNoteFromArray(avatar, 3);
				StopNoteFromArray(3, _decay);
			}
			
			
			if (Global.CheckKeyPressed(Global.J_KEY)){
				asdfjklKeyCounters[4] = 3;
				PlayNoteFromArray(avatar, 4);
				StopNoteFromArray(4, _decay);
			}
			
			if (Global.CheckKeyPressed(Global.K_KEY)){
				asdfjklKeyCounters[5] = 3;
				PlayNoteFromArray(avatar, 5);
				StopNoteFromArray(5, _decay);
			}
			
			if (Global.CheckKeyPressed(Global.L_KEY)){
				asdfjklKeyCounters[6] = 3;
				PlayNoteFromArray(avatar, 6);
				StopNoteFromArray(6, _decay);
			}
			
			if (Global.CheckKeyPressed(Global.SEMICOLON)){
				asdfjklKeyCounters[7] = 3;
				PlayNoteFromArray(avatar, 7);
				StopNoteFromArray(7, _decay);
			}
		}
		
		public function PlayedANote():Boolean
		{
			for (var i:int = 0; i < asdfjklKeyCounters.length; i++)
			{
				if (asdfjklKeyCounters[i] == 3) return true;
			}
			return false;
		}
	}
}