package Areas 
{
	import Entities.Avatar;
	import Entities.Tile;
	import LoaderManagers.PlayerInputManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.utils.*;
	
	public class Room 
	{
		public var L_bitmap:Bitmap;
		public var LevelRenderer:BitmapData;
		public var _id:int;
		public var width:int;
		public var height:int;
		
		[Embed(source = '../resources/images/tileset.png')]
		protected var tile_set:Class;
		
		public var map:Array;
		public var entities:Array;
		public var playerIndex:int = -1;
		public var pInput:PlayerInputManager;
		public var scaleArray:Array;
		
		public function Room(width:int, height:int, id:int)
		{
			LevelRenderer = new BitmapData(width, height, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			_id = id;
			this.width = width;
			this.height = height;
			
			map = [];
			for (var i:int = 0; i < height/16; i++){
				var row:Array = [];
				for (var j:int = 0; j < width/16; j++){
					if (i == height/16-1)
						row.push(new Tile(j*16, i*16, 1, 0, true));
					else{
						if (j == 0 || j == width/16-1)
							row.push(new Tile(j*16, i*16, 1, 0, true));
						else row.push (new Tile(j*16, i*16, 0, 0));
					}
				}
				map.push(row);
			}
			
			entities = [];
			pInput = new PlayerInputManager();
		}
		
		public function EnterRoom():void
		{
		}
		
		public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);
			
			var i:int, j:int;
			var tile_sheet:Bitmap = new tile_set();
			playerIndex = -1;
			for (i = entities.length-1; i >= 0; i--){
				if (entities[i] is Avatar) playerIndex = i;
				else entities[i].Render(LevelRenderer);
			}
			for (i = 0; i < map.length; i++){
				for (j = 0; j < map[i].length; j++){
					if (map[i][j].tileset_x == 0 && map[i][j].tileset_y == 0)
						continue;
					var sprite_x:int = map[i][j].tileset_x*16;
					var sprite_y:int = map[i][j].tileset_y*16;
					var draw_x:int = j*16;
					var draw_y:int = i*16;
					LevelRenderer.copyPixels(tile_sheet.bitmapData,
						new Rectangle(sprite_x, sprite_y, 16, 16),
						new Point(draw_x, draw_y));
				}
			}if (playerIndex >= 0)
				entities[playerIndex].Render(LevelRenderer);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(L_bitmap.x, L_bitmap.y);
			matrix.scale(Global.zoom, Global.zoom);
			Game.GameRenderer.draw(L_bitmap, matrix);
			LevelRenderer.unlock();
		}
		
		public function Update():void
		{
			if (playerIndex >= 0) 
				pInput.PlayerInput(entities, playerIndex);
			SpaceSlowTime();
			playerIndex = -1;
			var i:int;
			for (i = entities.length-1; i >= 0; i--){
				entities[i].Update(entities, map);
				if (entities[i].delete_me) entities.splice(i, 1);
			}for (i = 0; i < entities.length; i++){
				if (entities[i] is Avatar){ 
					playerIndex = i;
					break;
				}
			}
			
			if (playerIndex >= 0) UpdateView(entities[playerIndex]);
		}
		
		public function SpaceSlowTime():void
		{
			if (Global.CheckKeyDown(Global.SPACE))
				Global.CURR_PHYSICS_SPEED = (1 / Global.DELAY_AMOUNT);
			else
				Global.CURR_PHYSICS_SPEED = 1;
		}
		
		public function UpdateView(avatar:Avatar):void
		{
			var avirb:Number = avatar.x+avatar.rb+88;
			var avilb:Number = avatar.x+avatar.lb-88;
			var avitb:Number = avatar.y+avatar.tb-32;
			var avibb:Number = avatar.y+avatar.bb+16;
			if (!avatar.on_ground) avibb+=16;
			var right:Number = Global.stageWidth-L_bitmap.x;
			var left:Number = 0-(L_bitmap.x);
			var top:Number = 0-(L_bitmap.y);
			var bottom:Number = Global.stageHeight-L_bitmap.y;

			//move view right and left
			if (avirb > right)
				L_bitmap.x-= avatar.top_xspeed;
			else if (avilb < left)
				L_bitmap.x+= avatar.top_xspeed;
			//move view up and down
			if (avitb < top)
				L_bitmap.y += ((top - avitb));
			else if (avibb > bottom)
				L_bitmap.y-= ((avibb - bottom));

			if (avatar.on_ground && avitb-48 < top)
				L_bitmap.y += (6.0*Global.CURR_PHYSICS_SPEED);

			//prevent viewing off the edge
			if (L_bitmap.x < (-1)*(L_bitmap.width-Global.stageWidth))
				L_bitmap.x = (-1)*(L_bitmap.width-Global.stageWidth);
			if (L_bitmap.x > 0) L_bitmap.x = 0;

			if (L_bitmap.y < (L_bitmap.height-Global.stageHeight)*(-1))
				L_bitmap.y = (L_bitmap.height-Global.stageHeight)*(-1);
			if (L_bitmap.y > 0) L_bitmap.y = 0;
		}
		
		public function CreateScaleArray(root:int, mode:Array, top:int, bottom:int):void
		{
			//Create Diatonic Cmajor scale
			Game._noteArray = [];

			for (var i:int = 0; i < Global.ALL_PIANO_NOTE_STRINGS.length; i++)
			{
				var n:int = i + Global.PNOTE_OFFSET;
				if (n < top || n > bottom) continue;
				for (var j:int = 0; j < 6; j++)
				{
					if ((n-Math.abs(mode[j]+root-12))%12==0)
					{
						Game._noteArray.push(Global.ALL_PIANO_NOTE_STRINGS[i]);
						break;
					}
				}
			}
		}
	}
}