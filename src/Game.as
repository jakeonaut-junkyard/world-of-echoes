package  
{
	import Areas.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	public class Game
	{
		public var gameBitmap:Bitmap;
		public static var GameRenderer:BitmapData;
		
		public static var roomArray:Array;
		public static var roomIndex:int;
		
		public function Game()
		{
			trace("Game created!");
			
			GameRenderer = new BitmapData(Global.stageWidth*Global.zoom, Global.stageHeight*Global.zoom, false, 0x000000);
			gameBitmap = new Bitmap(GameRenderer);
			
			roomArray = [];
			roomArray.push(new Room(208, 160, 0));
			roomIndex = 0;
			
			Global.keys_pressed = new Array();
			Global.keys_down = new Array();
			Global.keys_up = new Array();
		}		
		
		public function Render():void
		{
			GameRenderer.lock();
			roomArray[roomIndex].Render();
			GameRenderer.unlock();
		}
		
		public function Update():void
		{	
			roomArray[roomIndex].Update();
			
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