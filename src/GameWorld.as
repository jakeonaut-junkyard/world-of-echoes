package  
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
	
	public class GameWorld
	{
		public var L_bitmap:Bitmap;
		public var LevelRenderer:BitmapData;
		
		public var width:int;
		public var height:int;
		public var baseX:int;
		
		[Embed(source = 'resources/images/tileset.png')]
		protected var tile_set:Class;
		
		public var map:Dictionary;
		public var entities:Array;
		public var playerIndex:int = -1;
		public var pInput:PlayerInputManager;
		
		public function GameWorld(width:int, height:int)
		{
			LevelRenderer = new BitmapData(width, height, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			this.width = width;
			this.height = height;
			
			map = new Dictionary();
			MapGenerator.GenerateField(map, width, height, 0);
			baseX = 240;
			
			entities = [];
			entities.push(new Avatar(240, height-125, 1));
			playerIndex = entities.length-1;
			pInput = new PlayerInputManager();
			
			CreateScaleArray(12, Global.DORIAN_MODE, 12, 48);
		}
		
		public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0xFFFFFF);
			LevelRenderer.fillRect(new Rectangle(baseX+240, 0, 1, LevelRenderer.height), 0x0000FF);
			LevelRenderer.fillRect(new Rectangle(baseX, 0, 1, LevelRenderer.height), 0xFF0000);
			
			var i:int, j:int;
			var tile_sheet:Bitmap = new tile_set();
			var foreground:Array = [];
			playerIndex = -1;
			for (i = entities.length-1; i >= 0; i--){
				if (entities[i] is Avatar) playerIndex = i;
				else entities[i].Render(LevelRenderer);
			}
			for each (var tile:Tile in map) {
				if (tile.solid) DrawMapPiece(tile, tile_sheet);
			}if (playerIndex >= 0) entities[playerIndex].Render(LevelRenderer);

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
				UpdateMap(entities[playerIndex]);
				UpdateView(entities[playerIndex]);
			}
		}
		
		public function UpdateMap(avatar:Avatar):void
		{
			var avirb:Number = avatar.x+avatar.rb+avatar.vel.x;
			var avilb:Number = avatar.x+avatar.lb+avatar.vel.x;
			var avitb:Number = avatar.y+avatar.tb-32;
			var avibb:Number = avatar.y+avatar.bb+16;
			if (!avatar.on_ground) avibb+=16;
			
			if (avirb > baseX+240 && avatar.facing==Global.RIGHT){
				trace("RIGHT!");
				MapGenerator.DeleteChunk(map, 240, height, baseX-240);
				MapGenerator.ShiftChunks(map, 240, height, baseX, 0, -240, 0);
				MapGenerator.ShiftChunks(map, 240, height, baseX+240, 0, -240, 0);
				MapGenerator.GenerateField(map, 240, height, baseX+240);
				ShiftEntities(-240, 0);
				L_bitmap.x+=240;
				trace("KEYS:"+countKeys(map));
			}else if (avilb < baseX && avatar.facing==Global.LEFT){
				trace("LEFT!");
				trace("KEYS:"+countKeys(map));
				MapGenerator.DeleteChunk(map, 240, height, baseX+240);
				MapGenerator.ShiftChunks(map, 480, height, baseX-240, 0, 240, 0);
				MapGenerator.GenerateField(map, 240, height, baseX-240);
				ShiftEntities(240, 0);
				L_bitmap.x-=240;
			}
		}
		
		public static function countKeys(myDictionary:Dictionary):int 
		{
			var n:int = 0;
			for (var key:* in myDictionary) {
				n++;
			}
			return n;
		}
		
		public function ShiftEntities(xShft:int, yShft:int):void
		{
			for (var i:int = 0; i < entities.length; i++){
				entities[i].x+=xShft;
				entities[i].y+=yShft;
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