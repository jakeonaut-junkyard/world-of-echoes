package Areas.Parents 
{
	import Entities.Avatar;
	import Entities.Tile;
	import LoaderManagers.PlayerInputManager;
	import LoaderManagers.SoundManager;
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
		
		public var width:int;
		public var height:int;
		public var room_row:int;
		public var room_column:int;
		
		[Embed(source = '../../resources/images/tileset.png')]
		protected var tile_set:Class;
		
		public var map:Array;
		public var entities:Array;
		public var playerIndex:int = -1;
		public var pInput:PlayerInputManager;
		
		public function Room(width:int, height:int, room_column:int, room_row:int)
		{
			LevelRenderer = new BitmapData(width, height, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			this.width = width;
			this.height = height;
			this.room_row = room_row;
			this.room_column = room_column;
			
			map = [];
			for (var i:int = 0; i < height/16; i++){
				var row:Array = [];
				for (var j:int = 0; j < width/16; j++){
					if (i == height/16-1 || i == 0)
						row.push(new Tile(j*16, i*16, 1, 0, true));
					else{
						row.push(new Tile(j*16, i*16, 0, 0));
					}
				}
				map.push(row);
			}
			
			entities = [];
			entities.push(new Avatar(32, height-33, 1));
			playerIndex = entities.length-1;
			pInput = new PlayerInputManager();
		}
		
		public function EnterRoom():void
		{
			SoundManager.getInstance().stopAllAmbientSounds();
			if (Game.roomRow == room_row && Game.roomColumn == room_column) return;
			var oldRoom:Room = Game.roomArray[Game.roomColumn][Game.roomRow];
			var oldEntities:Array = oldRoom.entities;
			
			pInput = oldRoom.pInput;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					playerIndex = i;
					for (var j:int = oldEntities.length-1; j >= 0; j--){
						if (oldEntities[j] is Avatar){
							var newX:Number, newY:Number;
							if (oldRoom.room_row > room_row)
								newX = width-32;
							else if (oldRoom.room_row < room_row) 
								newX = 16;
							else newX = oldEntities[j].x;
							newY = oldEntities[j].y - 
								((room_column - oldRoom.room_column) * 240);
							if (oldRoom.room_column > room_column)
								newY -= 16;
							else if (oldRoom.room_column < room_column) 
								newY += 16;
							
							entities[i].facing = oldEntities[j].facing;
							entities[i].vel = oldEntities[j].vel;
							entities[i].x = newX;
							entities[i].y = newY;
							UpdateView(entities[i]);
						}else if (oldEntities[j].isDisposable){
							oldEntities.splice(j, 1);
						}
					}
					break;
				}
			}
		}
		
		public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);
			
			var i:int, j:int;
			var tile_sheet:Bitmap = new tile_set();
			var foreground:Array = [];
			playerIndex = -1;
			for (i = entities.length-1; i >= 0; i--){
				if (entities[i] is Avatar) playerIndex = i;
				else entities[i].Render(LevelRenderer);
			}
			for (i = 0; i < map.length; i++){
				for (j = 0; j < map[i].length; j++){
					if (map[i][j].solid) DrawMapPiece(map[i][j], tile_sheet);
					else if (map[i][j].tileset_x != 0 || map[i][j].tileset_y != 0)
						foreground.push(map[i][j]);
				}
			}if (playerIndex >= 0)
				entities[playerIndex].Render(LevelRenderer);
			for (i = 0; i < foreground.length; i++){
				DrawMapPiece(foreground[i], tile_sheet);
			}
			
			var matrix:Matrix = new Matrix();
			matrix.translate(L_bitmap.x, L_bitmap.y);
			matrix.scale(Global.zoom, Global.zoom);
			Game.GameRenderer.draw(L_bitmap, matrix);
			LevelRenderer.unlock();
		}
		
		public function DrawMapPiece(tile:Tile, tile_sheet:Bitmap):void
		{
			var sprite_x:int = tile.tileset_x*16;
			var sprite_y:int = tile.tileset_y*16+tile.tb;
			var draw_x:int = tile.x;
			var draw_y:int = tile.y+tile.tb;
			LevelRenderer.copyPixels(tile_sheet.bitmapData,
				new Rectangle(sprite_x, sprite_y, 16, 16-tile.tb),
				new Point(draw_x, draw_y));
		}
		
		public function Update():void
		{
			if (playerIndex >= 0) pInput.PlayerInput(entities, playerIndex);
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
			
			if (playerIndex >= 0){ 
				UpdateRoomIndex(entities[playerIndex]);
				UpdateView(entities[playerIndex]);
			}
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
			if (avatar.vel.y > 0 && avatar.y < avatar.lastGroundY){ 
				var bottomOffset:Number = avatar.y - avatar.lastGroundY;
				if (bottomOffset < -64) bottomOffset = -64;
				bottom += bottomOffset;
			}

			//move view right and left
			if (avirb > right)
				L_bitmap.x+= (right - avirb);
			else if (avilb < left)
				L_bitmap.x+= (left - avilb);
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
		
		public function UpdateRoomIndex(avatar:Avatar):void
		{
			var roomRow:int = Game.roomRow;
			var roomColumn:int = Game.roomColumn;
			if (avatar.x < 0) roomRow--;
			else if (avatar.x+16 > width) roomRow++;
			else if (avatar.y < 0) roomColumn--;
			else if (avatar.y+16 > height) roomColumn++;
			
			if (roomRow != Game.roomRow || roomColumn != Game.roomColumn)
				Game.roomArray[roomColumn][roomRow].EnterRoom();
			Game.roomRow = roomRow;
			Game.roomColumn = roomColumn;
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
						if (n > top && n < bottom)
							Game._noteArray.push(Global.ALL_PIANO_NOTE_STRINGS[i]);
						break;
					}
				}
			}
		}
	}
}