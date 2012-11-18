package  
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.GameObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Game 
	{
		public var bitmap:Bitmap;
		public static var Renderer:BitmapData;
		
		//entities
		public var solids:Array;
		public var avatar:Avatar;
		public var bursts:Array;
		
		//managers
		public var musicInputManager:MusicalInputManager;
		
		public function Game()
		{
			trace("Game created!");
			
			Renderer = new BitmapData(Global.stageWidth*Global.zoom, Global.stageHeight*Global.zoom, false, 0x000000);
			bitmap = new Bitmap(Renderer);
			
			Global.keys_pressed = new Array();
			Global.keys_down = new Array();
			Global.keys_up = new Array();
			Global.CreateLetterDictionary();
			
			//create entities
			solids = [
				new GameObject(0, Global.stageHeight-32, 0, 0, Global.stageWidth, 32), //floor
				new GameObject(-16, 0, 0, 0, 16, Global.stageHeight), //Left wall
				new GameObject(Global.stageWidth, 0, 0, 0, 16, Global.stageHeight) //Right wall
			];
			avatar = new Avatar(Global.stageWidth/2-12, Global.stageHeight/2-12);
			bursts = [];
			
			//create managers
			musicInputManager = new MusicalInputManager();
			
			//TODO::!!!
			bursts.push(new Burst(avatar.x-20, avatar.y-20));
		}		
		
		public function Render():void
		{
			Renderer.lock();
			Renderer.fillRect(new Rectangle(0, 0, Renderer.width, Renderer.height), 0x000000);
			
			//draw bursts
			for (var i:int = 0; i < bursts.length; i++)
			{
				bursts[i].Render();
			}
			
			//draw land
			Renderer.fillRect(new Rectangle(0, (Global.stageHeight-32)*Global.zoom, 
				Global.stageWidth*Global.zoom, 32*Global.zoom), 0xFFFFFF);

			//draw player
			avatar.Render();
			
			Renderer.unlock();
		}
		
		public function Update():void
		{
			//update player input
			musicInputManager.MusicalInput(avatar);
			if (musicInputManager.PlayedANote())
				bursts.push(new Burst(avatar.x-20, avatar.y-20));
			
			//UPDATE THE ENTITIES
			avatar.Update(solids);
			for (var i:int = bursts.length-1; i >= 0; i--)
			{
				bursts[i].Update();
				if (!bursts[i].visible)
					bursts.splice(i, 1);
			}
			
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