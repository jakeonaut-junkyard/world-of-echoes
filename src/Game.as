package  
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.VoiceOrb;
	import Entities.GameObject;
	import Entities.SoundObjects.Arpeggio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.si.sion.SiONDriver;
	
	public class Game
	{
		public var bitmap:Bitmap;
		public static var Renderer:BitmapData;
		
		//entities
		public var solids:Array;
		public var avatar:Avatar;
		public var bursts:Array;
		public var voiceOrbs:Array;
		public var soundObjects:Array;
		
		//managers
		public var musicInputManager:MusicalInputManager;
		private var _driver:SiONDriver;
		
		public function Game()
		{
			trace("Game created!");
			
			Renderer = new BitmapData(Global.stageWidth*2*Global.zoom, Global.stageHeight*2*Global.zoom, false, 0x000000);
			bitmap = new Bitmap(Renderer);
			
			Global.keys_pressed = new Array();
			Global.keys_down = new Array();
			Global.keys_up = new Array();
			Global.CreateLetterDictionary();
			
			//create entities
			solids = [
				new GameObject(0, Global.stageHeight-32, 0, 0, (bitmap.width/Global.zoom)/2, 32), //floor1
				new GameObject(0, bitmap.height/Global.zoom-32, 0, 0, (bitmap.width/Global.zoom), 32), //floor 2
				new GameObject(-16, 0, 0, 0, 16, bitmap.height/Global.zoom), //Left wall
				new GameObject(bitmap.width/Global.zoom, 0, 0, 0, 16, bitmap.height/Global.zoom) //Right wall
			];
			avatar = new Avatar(Global.stageWidth/2-12, Global.stageHeight/2-12);
			bursts = [];
			voiceOrbs = [new VoiceOrb(Global.stageWidth/4, Global.stageHeight/4, avatar._voice)];
			soundObjects = [];
			
			//create managers
			musicInputManager = new MusicalInputManager();
			_driver = new SiONDriver();
			_driver.play('c0'); //IMPORTANT!!!
			
			//TODO::!!!
			bursts.push(new Burst(avatar.x-20, avatar.y-20, avatar._voice.color));
		}		
		
		public function Render():void
		{
			Renderer.lock();
			Renderer.fillRect(new Rectangle(0, 0, Renderer.width, Renderer.height), 0x000000);
			
			//draw bursts
			var i:int;
			for (i = 0; i < bursts.length; i++)
			{
				bursts[i].Render();
			}
			for (i = 0; i < voiceOrbs.length; i++)
			{
				voiceOrbs[i].Render();
			}
			
			//draw land
			for (i = 0; i < solids.length; i++)
			{
				var s:GameObject = solids[i];
				Renderer.fillRect(new Rectangle(s.x*Global.zoom, s.y*Global.zoom, 
					s.x*Global.zoom+s.rb*Global.zoom, s.y), 0xFFFFFF);
			}

			//draw player
			avatar.Render();
			
			Renderer.unlock();
		}
		
		public function Update():void
		{			
			//update player input
			musicInputManager.MusicalInput(avatar, _driver);
			if (musicInputManager.PlayedANote())
				bursts.push(new Burst(avatar.x-20, avatar.y-20, avatar._voice.color));
			
			//UPDATE THE ENTITIES
			avatar.Update(solids);
			var i:int;
			for (i = bursts.length-1; i >= 0; i--)
			{
				bursts[i].Update();
				if (!bursts[i].visible)
					bursts.splice(i, 1);
			}
			for (i = voiceOrbs.length-1; i >= 0; i--)
			{
				voiceOrbs[i].Update();
				
				var v:VoiceOrb = voiceOrbs[i];
				if (v.CheckRectIntersect(avatar, v.x+v.lb, v.y+v.tb, v.x+v.rb, v.y+v.bb))
				{
					//create audiovisual flair
					bursts.push(new Burst(v.x-16, v.y-16, v.voice.color))
					for (var j:int = soundObjects.length-1; j >= 0; j--)
					{
						if (soundObjects[j] is Arpeggio)
							soundObjects.splice(i, 1);
					}
					soundObjects.push(new Arpeggio(voiceOrbs[i].voice));
					
					//remove orb and update voice
					var tempVoice:VoiceManager = avatar._voice;
					avatar._voice = voiceOrbs[i].voice;
					voiceOrbs.splice(i, 1);
					
					//add new 
					var x:int = (Math.random()*(Global.stageWidth-128))+64;
					var y:int = (Math.random()*(Global.stageHeight-128))+64;
					voiceOrbs.push(new VoiceOrb(x, y, tempVoice));
				}
			}
			for (i = soundObjects.length-1; i >= 0; i--)
			{
				soundObjects[i].Update(_driver);
				if (soundObjects[i].dead)
					soundObjects.splice(i, 1);
			}
			
			//MOVE THE VIEW SCREEN
			UpdateView();
			
			//clear out the "keys_up" array for next update
			Global.keys_up = new Array();
			Global.keys_pressed = new Array();
		}
		
		public function UpdateView():void
		{
			var avirb:Number = avatar.x+avatar.rb+64;
			var avilb:Number = avatar.x+avatar.lb-64;
			var avitb:Number = avatar.y+avatar.tb-32;
			var avibb:Number = avatar.y+avatar.bb+64;
			var right:Number = Global.stageWidth-(bitmap.x/Global.zoom);
			var left:Number = 0-(bitmap.x/Global.zoom);
			var top:Number = 0-(bitmap.y/Global.zoom);
			var bottom:Number = Global.stageHeight-(bitmap.y/Global.zoom);
			
			//move view right and left
			if (avirb > right)
				bitmap.x-= (avirb - right);
			else if (avilb < left)
				bitmap.x+= (left - avilb);
			//move view up and down
			if (avitb < top)
				bitmap.y += (top - avitb);
			else if (avibb > bottom)
				bitmap.y-= (avibb - bottom);
				
			//prevent viewing off the edge
			if (bitmap.x < (-1)*(Global.stageWidth+bitmap.width/Global.zoom))
				bitmap.x = (-1)*(Global.stageWidth+bitmap.width/Global.zoom);
			if (bitmap.x > 0) bitmap.x = 0;
			
			if (bitmap.y < (bitmap.height-(Global.stageHeight*Global.zoom))*(-1))
				bitmap.y = (bitmap.height-(Global.stageHeight*Global.zoom))*(-1);
			if (bitmap.y > 0) bitmap.y = 0;
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