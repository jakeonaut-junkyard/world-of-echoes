package  
{
	import Entities.Avatar;
	import Areas.PentatonicMajor;
	import Areas.DiatonicMinor;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.si.sion.SiONDriver;
	
	public class Game
	{
		public static var _driver:SiONDriver;
		public var screenBitmap:Bitmap;
		public static var Screen:BitmapData;
		
		public var avatar:Avatar;
		public var musicInputManager:MusicalInputManager;
		
		//areas
		public static var areas:Array;
		public static var areaIndex:int;
		
		public function Game()
		{
			trace("Game created!");
			_driver = new SiONDriver();
			_driver.play('c0'); //TODO::
			
			Screen = new BitmapData(Global.stageWidth*Global.zoom, Global.stageHeight*Global.zoom, false, 0x000000);
			screenBitmap = new Bitmap(Screen);
			
			Global.keys_pressed = new Array();
			Global.keys_down = new Array();
			Global.keys_up = new Array();
			Global.CreateLetterDictionary();
			
			musicInputManager = new MusicalInputManager();
			
			areaIndex = 0;
			areas = [
				new PentatonicMajor(Global.stageWidth/2-12, Global.stageHeight/2-12, Global.PENTATONIC_MAJOR_AREA),
				new DiatonicMinor(Global.stageWidth/2-12, Global.stageHeight/2-12, Global.DIATONIC_MINOR_AREA)
			];
			
			avatar = new Avatar(0, 0, areas[areaIndex].scaleArray);
			areas[areaIndex].EnterRoom(avatar, Global.stageWidth/2, Global.stageHeight/2, null);
		}		
		
		public function Render():void
		{
			Screen.lock();
			areas[areaIndex].Render(avatar);
			Screen.unlock();
		}
		
		public function Update():void
		{						
			areas[areaIndex].Update(avatar, musicInputManager);
			//clear out the "keys_up" array for next update
			Global.keys_up = new Array();
			Global.keys_pressed = new Array();
		}
		
		/*************************************************************************************/
		//HANDLE AND DETECT INPUT
		/*************************************************************************************/
		
		public function KeyUp(e:KeyboardEvent):void
		{
			//position of key in the array
			var key_pos:int = -1;
			for (var i:int = 0; i < Global.keys_down.length; i++)
			{
				if (e.keyCode == Global.keys_down[i])
				{
					//the key is found/was pressed before, so store the position
					key_pos = i;
					break;
				}
			}
			//remove the keycode from keys_down if found
			if (key_pos!=-1)
				Global.keys_down.splice(key_pos, 1);
			
			Global.keys_up.push(e.keyCode);
		}
		
		public function KeyDown(e:KeyboardEvent):void
		{
			//check to see if the key that is being pressed is already in the array of pressed keys
			var key_down:Boolean = false;
			for (var i:int = 0; i < Global.keys_down.length; i++)
			{
				if (Global.keys_down[i] == e.keyCode)
					key_down = true;
			}
			
			//add the key to the array of pressed keys if it wasn't already in there
			if (!key_down)
			{
				Global.keys_down.push(e.keyCode);
				Global.keys_pressed.push(e.keyCode);
			}
		}
		
		public function MouseDown(e:MouseEvent):void
		{
			Global.mouse_X = e.stageX;
			Global.mouse_Y = e.stageY;
			Global.mousePressed = true;
		}
		
		public function MouseUp(e:MouseEvent):void
		{
			Global.mouse_X = e.stageX;
			Global.mouse_Y = e.stageY;
			Global.mousePressed = false;
		}
	}
}