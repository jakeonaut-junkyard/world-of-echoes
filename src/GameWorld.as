package  
{
	import Managers.VoiceManager;
	import Managers.MusicalInputManager;
	import Managers.SoundManager;
	import Entities.Avatar;
	import Entities.BassSquare;
	import Entities.BassBurst;
	import Entities.Burst;
	import Entities.Parents.GameObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	public class GameWorld
	{
		public var L_bitmap:Bitmap;
		public var LevelRenderer:BitmapData;
		
		//entities
		public var solids:Array;
		public var bursts:Array;
		public var bassBursts:Array;
		public var bassSquares:Array;
		
		//etc
		public var _voice:VoiceManager;
		public var scaleArray:Array;
		public var bassScaleArray:Array;
		public var groundColor:uint = 0xFFFFFF;
		
		public function GameWorld(avix:int, aviy:int) 
		{
			LevelRenderer = new BitmapData(Global.stageWidth*2, Global.stageHeight*1.5, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			
			_voice = new VoiceManager();
			_voice.SetVoice(12, 2);
			CreateScaleArray(12, Global.IONIAN_MODE);
			
			//create entities
			//create entities
			solids = [
				new GameObject(0, 0-16, 0, 0, L_bitmap.width, 32), //ceiling
				new GameObject(0, L_bitmap.height-32, 0, 0, (L_bitmap.width), 32), //floor
				new GameObject(0-16, 0, 0, 0, 32, Global.stageHeight-32), //Left wall
				new GameObject(L_bitmap.width-16, 0, 0, 0, 32, Global.stageHeight-16) //Right wall
			];
			bursts = [];
			bassBursts = [];
			bassSquares = [];
		}		
		
		public function EnterRoom(avatar:Avatar, avix:int, aviy:int, oldScale:Array = null):void
		{
			avatar._voice.TranslateNoteArray(scaleArray);
			avatar.x = avix;
			avatar.y = aviy;
			bassBursts = [];
			bursts = [];
			bassSquares = [];
			
			UpdateView(avatar);
			
			bassSquares = [
				new BassSquare(32, Global.stageHeight, _voice),
				new BassSquare(32+112, Global.stageHeight, _voice),
				new BassSquare(32+224, Global.stageHeight, _voice),
				new BassSquare(32+336, Global.stageHeight, _voice)
			];
		}
		
		public function Render(avatar:Avatar):void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);
			
			//draw audiovisual only objects
			var i:int;
			for (i = 0; i < bursts.length; i++){
				bursts[i].Render(LevelRenderer);
			}
			for (i = 0; i < bassBursts.length; i++){
				bassBursts[i].Render(LevelRenderer);
			}
			//draw land
			for (i = 0; i < solids.length; i++){
				var s:GameObject = solids[i];
				LevelRenderer.fillRect(new Rectangle(s.x, s.y, s.rb, s.bb), groundColor);
			}
			//draw interactive objects
			for (i = 0; i < bassSquares.length; i++){
				bassSquares[i].Render(LevelRenderer);
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
			musicInputManager.Update(avatar, scaleArray);
			if (musicInputManager.PlayedANote())
				bursts.push(new Burst(avatar.x-20, avatar.y-20, avatar._voice.color));
			if (musicInputManager.updateWorldScale)
			{
				musicInputManager.updateWorldScale = false;
				ChangeWorldScale(avatar, musicInputManager.rootNote);
			}
			
			if (Global.CheckKeyDown(Global.SPACE)){
				Global.CURR_PHYSICS_SPEED = 1 / Global.DELAY_AMOUNT;
			}
			else{ 
				Global.CURR_PHYSICS_SPEED = 1;
			}
			
			//UPDATE THE ENTITIES
			avatar.Update(solids);
			var i:int;
			for (i = bursts.length-1; i >= 0; i--){
				bursts[i].Update();
				if (!bursts[i].visible)
					bursts.splice(i, 1);
			}
			for (i = bassBursts.length-1; i >= 0; i--){
				bassBursts[i].Update();
				if (!bassBursts[i].visible)
				{
					bassBursts.splice(i, 1);
				}
			}
			for (i = bassSquares.length-1; i >= 0; i--){
				bassSquares[i].Update(avatar, bassScaleArray);
				var tempSquare:BassSquare = bassSquares[i];
				if (!tempSquare.visible){
					bassBursts.push(new BassBurst(tempSquare.x+10, tempSquare.y+10, tempSquare._voice.color));
					ChangeWorldScale(avatar, bassSquares[i].noteIndex);
					bassSquares.splice(i, 1);
				}
			}
			
			//MOVE THE VIEW SCREEN
			UpdateView(avatar);
		}
		
		public function UpdateView(avatar:Avatar):void
		{
			var avirb:Number = avatar.x+avatar.rb+96;
			var avilb:Number = avatar.x+avatar.lb-96;
			var avitb:Number = avatar.y+avatar.tb-32;
			var avibb:Number = avatar.y+avatar.bb+48;
			if (!avatar.on_ground) avibb+=16;
			var right:Number = Global.stageWidth-L_bitmap.x;
			var left:Number = 0-(L_bitmap.x);
			var top:Number = 0-(L_bitmap.y);
			var bottom:Number = Global.stageHeight-L_bitmap.y;
			
			//move view right and left
			if (avirb > right)
			{
				L_bitmap.x-= ((avirb - right)*Global.CURR_PHYSICS_SPEED);
			}
			else if (avilb < left)
			{
				L_bitmap.x+= ((left - avilb)*Global.CURR_PHYSICS_SPEED);
			}
			//move view up and down
			if (avitb < top)
			{
				L_bitmap.y += ((top - avitb)*Global.CURR_PHYSICS_SPEED);
			}
			else if (avibb > bottom)
				L_bitmap.y-= ((avibb - bottom)*Global.CURR_PHYSICS_SPEED);
				
			if (avatar.on_ground && avitb-48 < top)
					L_bitmap.y += (6*Global.CURR_PHYSICS_SPEED);
				
			//prevent viewing off the edge
			if (L_bitmap.x < (-1)*(L_bitmap.width-Global.stageWidth))
				L_bitmap.x = (-1)*(L_bitmap.width-Global.stageWidth);
			if (L_bitmap.x > 0) L_bitmap.x = 0;
			
			if (L_bitmap.y < (L_bitmap.height-Global.stageHeight)*(-1))
				L_bitmap.y = (L_bitmap.height-Global.stageHeight)*(-1);
			if (L_bitmap.y > 0) L_bitmap.y = 0;
			
			//rectify
			L_bitmap.x = Math.floor(L_bitmap.x);
			L_bitmap.y = Math.floor(L_bitmap.y);
		}
		
		public function CreateScaleArray(root:int, mode:Array):void
		{
			//Create Diatonic Cmajor scale
			bassScaleArray = [];
			scaleArray = [];
			
			for (var i:int = 24; i < 84; i++)
			{
				for (var j:int = 0; j < 6; j++)
				{
					if ((i-Math.abs(mode[j]+root-12))%12==0)
					{
						if (i >= 36)
							scaleArray.push(i);
						else
							bassScaleArray.push(i);
						break;
					}
				}
			}
		}
		
		public function ChangeWorldScale(avatar:Avatar, bassNote:int):void
		{
			//CHOOSE NEXT SCALE RANDOMLY
			var scales:Array = [Global.IONIAN_MODE, Global.DORIAN_MODE, Global.PHRYGIAN_MODE,
				Global.LYDIAN_MODE, Global.MIXOLYDIAN_MODE, Global.AEOLIAN_MODE, Global.LOCRIAN_MODE];
				
			var rootNote:int = (bassNote%12)+12;
			var randIndex:int = Math.floor(Math.random()*7);
			CreateScaleArray(rootNote, scales[randIndex]);
			
			//SET ENTITIES IN THE WORLD TO THE NEW SCALE
			var i:int;
			for (i = 0; i < bassSquares.length; i++)
			{
				bassSquares[i]._voice.TranslateNoteArray(bassScaleArray);
			}
			avatar._voice.TranslateNoteArray(scaleArray);
		}
	}
}