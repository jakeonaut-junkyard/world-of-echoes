package  
{
	public class Global 
	{	
		public static var stageWidth:int = 213;
		public static var stageHeight:int = 160;
		public static var zoom:int = 3;
		
		public static const DELAY_AMOUNT:Number = 8;
		public static var CURR_PHYSICS_SPEED:Number = 1;
		
		//mouse input stuff
		public static var mousePressed:Boolean;
		public static var mouse_X:Number;
		public static var mouse_Y:Number;
		
		//keyboard input stuff
		public static var keys_down:Array;
		public static var keys_up:Array;
		public static var keys_pressed:Array;
		
		public static const LEFT:int = 37;
		public static const UP:int = 38;
		public static const RIGHT:int = 39;
		public static const DOWN:int = 40;
		public static const SPACE:int = 32;
		public static const ENTER:int = 13;
		public static const ESC:int = 27;
		public static const BACKSPACE:int = 8;
		public static const SHIFT:int = 16;
		public static const A_KEY:int = 65;
		public static const S_KEY:int = 83;
		public static const D_KEY:int = 68;
		public static const F_KEY:int = 70;
		public static const J_KEY:int = 74;
		public static const K_KEY:int = 75;
		public static const L_KEY:int = 76;
		public static const X_KEY:int = 88;
		public static const SEMICOLON:int = 186;
		public static const Q_KEY:int = 81;
		public static const W_KEY:int = 87;
		public static const E_KEY:int = 69;
		public static const R_KEY:int = 82;
		
		//track ids for SiON
		public static const AVATAR_VOICE_ID:int = 0;
		public static const BASS_SQUARE_TRACK_ID:int = 1;
		
		//Musical Scale Modes
		public static const IONIAN_MODE:Array = [0, 2, 4, 5, 7, 9, 11];
		public static const DORIAN_MODE:Array = [0, 2, 3, 5, 7, 9, 10];
		public static const PHRYGIAN_MODE:Array = [0, 1, 3, 5, 7, 8, 10];
		public static const LYDIAN_MODE:Array = [0, 2, 4, 6, 7, 9, 11];
		public static const MIXOLYDIAN_MODE:Array = [0, 2, 4, 5, 7, 9, 10];
		public static const AEOLIAN_MODE:Array = [0, 2, 3, 5, 7, 8, 10];
		public static const LOCRIAN_MODE:Array = [0, 1, 3, 5, 6, 8, 10];
		
		//room ids
		public static const PENTATONIC_MAJOR_AREA:int = 0;
		public static const DIATONIC_MINOR_AREA:int = 1;
		public static const FIELD_IONIC_PENTATONIC_AREA:int = 2;
		
		public function Global(){}	
		
		public static function CheckKeyDown(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_down.length; i++)
			{
				if (keys_down[i] == keycode)
				{
					answer = true;
					break;
				}
			}
			return answer;
		}
		
		public static function CheckKeyPressed(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_pressed.length; i++)
			{
				if (keys_pressed[i] == keycode)
				{
					answer = true;
					break;
				}
			}
			return answer;
		}
		
		public static function CheckKeyUp(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_up.length; i++)
			{
				if (keys_up[i] == keycode)
				{
					answer = true;
					break;
				}
			}
			return answer;
		}
	}
}