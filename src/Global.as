package  
{
	import flash.utils.Dictionary;
	 
	public class Global 
	{	
		public static var stageWidth:int = 213;
		public static var stageHeight:int = 160;
		public static var zoom:int = 3;
		
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
		public static const A_KEY:int = 65;
		public static const S_KEY:int = 83;
		public static const D_KEY:int = 68;
		public static const F_KEY:int = 70;
		public static const J_KEY:int = 74;
		public static const K_KEY:int = 75;
		public static const L_KEY:int = 76;
		public static const SEMICOLON:int = 186;
		public static const Q_KEY:int = 81;
		public static const W_KEY:int = 87;
		public static const E_KEY:int = 69;
		public static const R_KEY:int = 82;
		public static const SPACE:int = 32;
		public static const ENTER:int = 13;
		public static const ESC:int = 27;
		public static const BACKSPACE:int = 8;
		public static const SHIFT:int = 16;
		public static const UNDERSCORE:int = 189;
		public static var LetterKeys:Dictionary;
		
		public function Global() 
		{
			
		}	

		public static function CreateLetterDictionary():void
		{
			LetterKeys = new Dictionary();
			
			//ADD NUMBERS
			for (var i:int = 48; i < 58; i++)
			{
				LetterKeys[i] = "0123456789".charAt(i-48);
			}
			for (var i:int = 96; i < 106; i++)
			{
				LetterKeys[i] = "0123456789".charAt(i-96);
			}
			
			//ADD LETTERS
			for (var i:int = 65; i < 91; i++)
			{
				LetterKeys[i] = "abcdefghijklmnopqrstuvwxyz".charAt(i-65);
			}
			
			trace("DICTIONARY CREATED!!");
		}
		
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