package  
{
	import Entities.*;
	import LoaderManagers.EnvironmentManager;
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
		public var chunkWidth:int = 240;
		public var chunkHeight:int = 160;
		public var baseX:int;
		public var baseY:int;
		public static const GROUND_LEVEL:int = 320;
		
		[Embed(source = 'resources/images/tileset.png')]
		protected var tile_set:Class;
		
		public var modeArray:Array;
		public var currMode:int;
		
		public var terrain:int;
		public static var environment:EnvironmentManager;
		public var map:Dictionary;
		public var entities:Array;
		public var playerIndex:int = -1;
		public static var pInput:PlayerInputManager;
		
		public function GameWorld(width:int, height:int)
		{
			LevelRenderer = new BitmapData(width, height, false, 0x000000);
			L_bitmap = new Bitmap(LevelRenderer);
			this.width = width;
			this.height = height;
			
			modeArray = [];
			modeArray.push(Global.IONIAN_MODE);
			modeArray.push(Global.DORIAN_MODE);
			modeArray.push(Global.PHRYGIAN_MODE);
			modeArray.push(Global.LYDIAN_MODE);
			modeArray.push(Global.MIXOLYDIAN_MODE);
			modeArray.push(Global.AEOLIAN_MODE);
			modeArray.push(Global.LOCRIAN_MODE);
			currMode = 1;
			
			terrain = Global.FOREST_FIELD_TERRAIN;
			environment = new EnvironmentManager();
			map = new Dictionary();
			MapGenerator.GenerateMap(terrain, map, width, chunkHeight, 0, 0, false);
			MapGenerator.GenerateMap(terrain, map, width, chunkHeight, 0, chunkHeight, true);
			//MapGenerator.GenerateMap(terrain, map, width, chunkHeight, 0, chunkHeight*2, true);
			baseX = 240;
			baseY = GROUND_LEVEL;
			
			entities = [];
			entities.push(new Avatar(240, height-baseY));
			playerIndex = entities.length-1;
			pInput = new PlayerInputManager();
			//entities.push(new GlowbugSwarm(208, height-125));
			EntitySpawner.SpawnEntities(terrain, entities, map, width, height, 0, 0);
			
			CreateScaleArray(12, modeArray[currMode], 19, 48);
		}
		
		public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0xFFFFFF);
			//LevelRenderer.fillRect(new Rectangle(baseX+240, 0, 1, LevelRenderer.height), 0x0000FF);
			//LevelRenderer.fillRect(new Rectangle(baseX, 0, 1, LevelRenderer.height), 0xFF0000);
			
			var i:int, j:int;
			var tile_sheet:Bitmap = new tile_set();
			var foreground:Array = [];
			playerIndex = -1;
			for (i = entities.length-1; i >= 0; i--){
				if (entities[i] is Avatar) playerIndex = i;
				else entities[i].Render(LevelRenderer);
			}
			environment.Render(LevelRenderer, L_bitmap);
			for each (var tile:Tile in map) {
				if (tile.solid) DrawMapPiece(tile, tile_sheet);
				else if (!(tile.tileset_x == 0 && tile.tileset_y == 0))
					foreground.push(tile);
			}if (playerIndex >= 0) entities[playerIndex].Render(LevelRenderer);
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
			var pX:Number;
			var pY:Number;
			if (playerIndex >= 0){ 
				pInput.PlayerInput(entities, playerIndex);
				pX = entities[playerIndex].x;
				pY = entities[playerIndex].y;
			}
			playerIndex = -1;
			var i:int;
			for (i = entities.length-1; i >= 0; i--){
				if (entities[i].x > pX + 16 + 200 || entities[i].x < pX - 200 ||
					entities[i].y > pY + 16 + 200 || entities[i].y < pY - 200){
						if (entities[i].isDisposable) entities.splice(i, 1);
						continue;
				}
				entities[i].Update(entities, map);
				if (entities[i].delete_me) entities.splice(i, 1);
			}for (i = 0; i < entities.length; i++){
				if (entities[i] is Avatar){ 
					playerIndex = i;
					break;
				}
			}
			
			environment.Update(entities);
			if (playerIndex >= 0){
				UpdateMap(entities[playerIndex]);
				UpdateView(entities[playerIndex]);
			}
		}
		
		public function UpdateMap(avatar:Avatar):void
		{
			var avirb:Number = avatar.x+avatar.rb+avatar.vel.x;
			var avilb:Number = avatar.x+avatar.lb+avatar.vel.x;
			var avitb:Number = avatar.y+avatar.tb+160;
			var avibb:Number = avatar.y+avatar.bb+160;
			if (!avatar.on_ground) avibb+=16;
			var calcX:int = 240;
			var calcY:int = 320;
			
			//FIRST HORIZONTAL
			var groundLevel:Boolean = (baseY == GROUND_LEVEL);
			var spawnHeight:int = chunkHeight*3;
			if (baseY == GROUND_LEVEL){ 
				spawnHeight = chunkHeight;
				groundLevel = true;
			}else if (baseY == GROUND_LEVEL-chunkHeight){
				spawnHeight = chunkHeight*2;
				groundLevel = true;
			}
			
			if (avirb > calcX+chunkWidth && avatar.facing==Global.RIGHT){
				//trace("RIGHT!");
				baseX+=chunkWidth;
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, chunkWidth, spawnHeight, calcX-chunkWidth, calcY-chunkHeight);
				MapGenerator.ShiftChunks(map, chunkWidth, spawnHeight, calcX, calcY-chunkHeight, -chunkWidth, 0);
				MapGenerator.ShiftChunks(map, chunkWidth, spawnHeight, calcX+chunkWidth, calcY-chunkHeight, -chunkWidth, 0);
				MapGenerator.GenerateMap(terrain, map, chunkWidth, spawnHeight, calcX+chunkWidth, calcY-chunkHeight, groundLevel);
				EntitySpawner.Despawn(avatar, entities);
				ShiftEntities(-chunkWidth, 0);
				EntitySpawner.SpawnEntities(terrain, entities, map, chunkWidth, spawnHeight, calcX+chunkWidth, calcY-chunkHeight);
				L_bitmap.x+=chunkWidth;
			}else if (avilb < calcX && avatar.facing==Global.LEFT){
				//trace("LEFT!");
				baseX-=chunkWidth;
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, chunkWidth, spawnHeight, calcX+chunkWidth, calcY-chunkHeight);
				MapGenerator.ShiftChunks(map, chunkWidth*2, spawnHeight, calcX-chunkWidth, calcY-chunkHeight, chunkWidth, 0);
				MapGenerator.GenerateMap(terrain, map, chunkWidth, spawnHeight, calcX-chunkWidth, calcY-chunkHeight, groundLevel);
				EntitySpawner.Despawn(avatar, entities);
				ShiftEntities(chunkWidth, 0);
				EntitySpawner.SpawnEntities(terrain, entities, map, chunkWidth, spawnHeight, calcX-chunkWidth, calcY-chunkHeight);
				L_bitmap.x-=chunkWidth;
			}
			//NOW FOR VERTICAL
			else if (avibb > calcY+chunkHeight && avatar.vel.y > 0 && baseY != GROUND_LEVEL){
				//trace("DOWN!");
				baseY+=chunkHeight;
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY-chunkHeight);
				MapGenerator.ShiftChunks(map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY, 0, -chunkHeight);
				MapGenerator.ShiftChunks(map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY+chunkHeight, 0, -chunkHeight);
				MapGenerator.GenerateMap(terrain, map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY+chunkHeight, baseY == GROUND_LEVEL);
				EntitySpawner.Despawn(avatar, entities);
				ShiftEntities(0, -chunkHeight);
				EntitySpawner.SpawnEntities(terrain, entities, map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY+chunkHeight);
				L_bitmap.y+=chunkHeight;
			}else if (avitb < calcY && avatar.vel.y < 0){
				//trace("UP!");
				baseY-=chunkHeight
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY+chunkHeight);
				MapGenerator.ShiftChunks(map, chunkWidth*3, chunkHeight*2, calcX-chunkWidth, calcY-chunkHeight, 0, chunkHeight);
				MapGenerator.GenerateMap(terrain, map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY-chunkHeight, baseY == GROUND_LEVEL);
				EntitySpawner.Despawn(avatar, entities);
				ShiftEntities(0, chunkHeight);
				EntitySpawner.SpawnEntities(terrain, entities, map, chunkWidth*3, chunkHeight, calcX-chunkWidth, calcY-chunkHeight);
				L_bitmap.y-=chunkHeight;
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

			//prevent viewing off the edge
			if (L_bitmap.x < (-1)*(L_bitmap.width-Global.stageWidth))
				L_bitmap.x = (-1)*(L_bitmap.width-Global.stageWidth);
			if (L_bitmap.x > 0) L_bitmap.x = 0;

			if (L_bitmap.y < (L_bitmap.height-Global.stageHeight)*(-1))
				L_bitmap.y = (L_bitmap.height-Global.stageHeight)*(-1);
			if (L_bitmap.y > 0) L_bitmap.y = 0;
		}
		
		public function TryToChangeScaleArray():void
		{
			var newRand:int, root:int;
			var rand:int = Math.floor(Math.random()*5);
			if (rand <= 1) return;
			else if (rand < 4){
				root = Game._SiONArray[0];
				newRand = Math.floor(Math.random()*3)+1;
				root = Game._SiONArray[newRand];
				CreateScaleArray(root, modeArray[currMode], 19, 48);
			}else if (rand >= 4){
				root = Game._SiONArray[0];
				newRand = Math.floor(Math.random()*modeArray.length)+1;
				currMode += newRand;
				if (currMode >= modeArray.length) currMode -= modeArray.length;
				CreateScaleArray(root, modeArray[currMode], 19, 48);
			}
		}
		
		public function CreateScaleArray(root:int, mode:Array, top:int, bottom:int):void
		{
			Game._SiONArray = [];
			
			for (var i:int = top; i < bottom; i++){
				for (var j:int = 0; j < 6; j++)
				{
					if ((i-Math.abs(mode[j]+root-12))%12==0){
						Game._SiONArray.push(i);
					}
				}
			}
			trace(Game._SiONArray);
		}
	}
}