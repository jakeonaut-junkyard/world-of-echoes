package  
{
	import Entities.Avatar;
	import org.si.sion.SiONDriver;
	
	public class MusicalInputManager 
	{
		private var _driver:SiONDriver;
		private var _voice:VoiceManager;
		private var asdfjklKeys:Array;
		
		private var pressing_jump:Boolean = false;
		private var stopRunCounter:int;
		
		public function MusicalInputManager() 
		{
			_driver = new SiONDriver();
			_voice = new VoiceManager();
			_driver.play('c0'); //IMPORTANT!!!
			
			asdfjklKeys = [false, false, false, false, false, false, false, false];
			stopRunCounter = 0;
		}
		
		public function MusicalInput(avatar:Avatar):void
		{
			UpdateKeyArray();
			
			//play the notes
			for (var i:int = 0; i < asdfjklKeys.length; i++)
			{
				if (asdfjklKeys[i])
				{
					_driver.noteOn(_voice.noteArray[i], _voice.voice, 4);
					
					if (i <= 3) i = 4;
					else break;
				}
			}
			
			PlayerRun(avatar);
			PlayerJump(avatar);
			
			//DEBUG:: Create new instrument
			if (Global.CheckKeyPressed(Global.ENTER))
			{
				_voice.CreateRandomInstrument();
			}
		}
		
		private function PlayerRun(avatar:Avatar):void
		{
			//move the player //LEFT
			var i:int;
			var move:Boolean = false;
			for (i = 0; i < 4; i++){
				if (asdfjklKeys[i]){
					move = true;
					break;
				}
			}
			if (move){
				avatar.vel.x = -avatar.top_xspeed;
				avatar.facing = Global.LEFT;
				stopRunCounter = 10;
				
				if (avatar.on_ground)
					avatar.move_state = avatar.RUNNING;
			}
			
			//move the player //RIGHT
			move = false;
			for (i = 4; i < 8; i++){
				if (asdfjklKeys[i]){
					move = true;
					break;
				}
			}
			if (move){
				avatar.vel.x = avatar.top_xspeed;
				avatar.facing = Global.RIGHT;
				stopRunCounter = 10;
				
				if (avatar.on_ground)
					avatar.move_state = avatar.RUNNING;
			}
			
			//STOP MOVEMENT
			stopRunCounter--;
			if (stopRunCounter <= 0){
				stopRunCounter = 0;
				avatar.vel.x = 0;
				
				if (avatar.on_ground)
					avatar.move_state = avatar.STANDING;
			}
		}
		
		private function PlayerJump(avatar:Avatar):void
		{
			//JUMPING
			if (Global.CheckKeyPressed(Global.UP) && avatar.on_ground)
			{
				pressing_jump = true;
				avatar.on_ground = false;
				avatar.vel.y -= avatar.jump_vel;
			}
			if (stopRunCounter > 0 && !avatar.on_ground)
			{
				avatar.y-=2;
				if (avatar.vel.y > 0)
					avatar.y-=1;
			}
		}
		
		public function PlayedANote():Boolean
		{
			for (var i:int = 0; i < asdfjklKeys.length; i++)
			{
				if (asdfjklKeys[i]) return true;
			}
			return false;
		}
		
		private function UpdateKeyArray():void
		{
			if (Global.CheckKeyPressed(Global.A_KEY))
				asdfjklKeys[0] = true;
			else asdfjklKeys[0] = false;
				
			if (Global.CheckKeyPressed(Global.S_KEY))
				asdfjklKeys[1] = true;
			else asdfjklKeys[1] = false;
			
			if (Global.CheckKeyPressed(Global.D_KEY))
				asdfjklKeys[2] = true;
			else asdfjklKeys[2] = false;
			
			if (Global.CheckKeyPressed(Global.F_KEY))
				asdfjklKeys[3] = true;
			else asdfjklKeys[3] = false;
			
			if (Global.CheckKeyPressed(Global.J_KEY))
				asdfjklKeys[4] = true;
			else asdfjklKeys[4] = false;
			
			if (Global.CheckKeyPressed(Global.K_KEY))
				asdfjklKeys[5] = true;
			else asdfjklKeys[5] = false;
			
			if (Global.CheckKeyPressed(Global.L_KEY))
				asdfjklKeys[6] = true;
			else asdfjklKeys[6] = false;
			
			if (Global.CheckKeyPressed(Global.SEMICOLON))
				asdfjklKeys[7] = true;
			else asdfjklKeys[7] = false;
		}
	}
}