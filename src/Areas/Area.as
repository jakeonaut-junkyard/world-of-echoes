package Areas 
{

	import Entities.Avatar;
	import Entities.Burst;
	import Entities.VoiceOrb;
	import Entities.GameObject;
	import Entities.SoundObjects.Arpeggio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	public class Area
	{
		public var id:int;
		public var L_bitmap:Bitmap;
		public var LevelRenderer:BitmapData;
		
		//entities
		public var solids:Array;
		public var bursts:Array;
		public var voiceOrbs:Array;
		public var soundObjects:Array;
		public var doors:Array;
		
		public var scaleArray:Array;
		
		//etc
		public var groundColor:uint = 0xFFFFFF;
		
		public function Area(avix:int, aviy:int, width:int, height:int, id:int) 
		{
			this.id = id;
			LevelRenderer = new BitmapData(width, height, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			CreateScaleArray();
			
			//create entities
			solids = [
				new GameObject(0, L_bitmap.height-32, 0, 0, (L_bitmap.width), 32), //floor
				new GameObject(-16, 0, 0, 0, 32, L_bitmap.height), //Left wall
				new GameObject(L_bitmap.width-16, 0, 0, 0, 32, L_bitmap.height) //Right wall
			];
			bursts = [];
			voiceOrbs = [];
			soundObjects = [];
			doors = [];
		}		
		
		public function EnterRoom(avatar:Avatar, avix:int, aviy:int):void
		{
			avatar._voice.SetRandomNoteArray(scaleArray);
			avatar.x = avix;
			avatar.y = aviy;
			
			UpdateView(avatar);
		}
		
		public function Render(avatar:Avatar):void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);
			
			//draw bursts
			var i:int;
			for (i = 0; i < bursts.length; i++)
			{
				bursts[i].Render(LevelRenderer);
			}
			for (i = 0; i < voiceOrbs.length; i++)
			{
				voiceOrbs[i].Render(LevelRenderer);
			}
			//draw land
			for (i = 0; i < solids.length; i++)
			{
				var s:GameObject = solids[i];
				LevelRenderer.fillRect(new Rectangle(s.x, s.y, s.rb, s.bb), groundColor);
			}
			//debug (DRAW DOORS)
			for (i = 0; i < doors.length; i++)
			{
				var d:GameObject = doors[i];
				LevelRenderer.fillRect(new Rectangle(d.x, d.y, d.rb, d.bb), 0xFF00FF);
			}

			//draw player
			avatar.Render(LevelRenderer);
			
			//Draw LevelRenderer on to screen
			var matrix:Matrix = new Matrix();
			matrix.translate(L_bitmap.x, L_bitmap.y);
			matrix.scale(Global.zoom, Global.zoom);
			Game.Screen.draw(L_bitmap, matrix);
			LevelRenderer.unlock();
		}
		
		public function Update(avatar:Avatar, musicInputManager:MusicalInputManager):void
		{
			//update player input
			musicInputManager.MusicalInput(avatar, scaleArray);
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
				}
			}
			for (i = soundObjects.length-1; i >= 0; i--)
			{
				soundObjects[i].Update();
				if (soundObjects[i].dead)
					soundObjects.splice(i, 1);
			}
			for (i = 0; i < doors.length; i++)
			{
				doors[i].Update(avatar);
			}
			
			//MOVE THE VIEW SCREEN
			UpdateView(avatar);
		}
		
		public function UpdateView(avatar:Avatar):void
		{
			var avirb:Number = avatar.x+avatar.rb+64;
			var avilb:Number = avatar.x+avatar.lb-64;
			var avitb:Number = avatar.y+avatar.tb-32;
			var avibb:Number = avatar.y+avatar.bb+64;
			var right:Number = Global.stageWidth-L_bitmap.x;
			var left:Number = 0-(L_bitmap.x);
			var top:Number = 0-(L_bitmap.y);
			var bottom:Number = Global.stageHeight-L_bitmap.y;
			
			//move view right and left
			if (avirb > right)
				L_bitmap.x-= (avirb - right);
			else if (avilb < left)
				L_bitmap.x+= (left - avilb);
			//move view up and down
			if (avitb < top)
				L_bitmap.y += (top - avitb);
			else if (avibb > bottom)
				L_bitmap.y-= (avibb - bottom);
				
			//prevent viewing off the edge
			if (L_bitmap.x < (-1)*(L_bitmap.width-Global.stageWidth))
				L_bitmap.x = (-1)*(L_bitmap.width-Global.stageWidth);
			if (L_bitmap.x > 0) L_bitmap.x = 0;
			
			if (L_bitmap.y < (L_bitmap.height-Global.stageHeight)*(-1))
				L_bitmap.y = (L_bitmap.height-Global.stageHeight)*(-1);
			if (L_bitmap.y > 0) L_bitmap.y = 0;
		}
		
		public function CreateScaleArray():void
		{
			//Create Diatonic Cmajor scale
			scaleArray = [];
			for (var i:int = 24; i < 84; i++)
			{
				if (i%12==0 || 		//C
					(i-2)%12==0 ||	//D
					(i-4)%12==0 || 	//E
					(i-5)%12==0 || 	//F
					(i-7)%12==0 ||	//G
					(i+3)%12==0 ||	//A
					(i+1)%12==0) 	//B
				scaleArray.push(i);
			}
		}
	}
}