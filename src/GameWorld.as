package  
{
	import Entities.*;
	import Entities.Parents.*;
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
		public static const C_WIDTH:int = 240;
		public static const C_HEIGHT:int = 160;
		public static var baseX:int;
		public static var baseY:int;
		public static const GROUND_LEVEL:int = 160;
		
		[Embed(source = 'resources/images/tileset.png')]
		protected var tile_set:Class;
		
		public var modeArray:Array;
		public var currMode:int;
		
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
			
			environment = new EnvironmentManager();
			map = new Dictionary();
			baseX = 0;
			baseY = GROUND_LEVEL;			
			entities = [];
			entities.push(new Avatar(240, (2*height/3)-32));
			playerIndex = entities.length-1;
			pInput = new PlayerInputManager();
			//entities.push(new GlowbugSwarm(208, height-125));
			for (var i:int = 0; i < 3; i++){
				MapGenerator.GenerateMap(baseX, baseY, map, C_WIDTH, C_HEIGHT, i*C_WIDTH, C_HEIGHT);
				EntitySpawner.SpawnEntities(baseX, baseY, entities, map, C_WIDTH, C_HEIGHT, i*C_WIDTH, C_HEIGHT, Global.RIGHT);
			}
			
			CreateScaleArray(12, modeArray[currMode], 19, 48);
		}
		
		public function Render():void
		{
			var bgColor:uint = 0xFFFFFF;
			bgColor = environment.bgColor;
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), bgColor);
			//LevelRenderer.fillRect(new Rectangle(baseX+240, 0, 1, LevelRenderer.height), 0x0000FF);
			//LevelRenderer.fillRect(new Rectangle(baseX, 0, 1, LevelRenderer.height), 0xFF0000);
			
			var i:int, j:int;
			var tile_sheet:Bitmap = new tile_set();
			var foreground:Array = [];
			playerIndex = -1;
			for (i = entities.length-1; i >= 0; i--){
				if (entities[i] is Avatar) playerIndex = i;
				else if (entities[i] is GameSprite && entities[i].foreground)
					foreground.push(entities[i]);
				else entities[i].Render(LevelRenderer);
			}
			environment.Render(LevelRenderer, L_bitmap);
			for each (var tile:Tile in map) {
				if (tile.solid) DrawMapPiece(tile, tile_sheet);
				else if (!(tile.tileset_x == 0 && tile.tileset_y == 0))
					foreground.push(tile);
			}if (playerIndex >= 0) entities[playerIndex].Render(LevelRenderer);
			for (i = 0; i < foreground.length; i++){
				if (foreground[i] is Tile)
					DrawMapPiece(foreground[i], tile_sheet);
				else foreground[i].Render(LevelRenderer);
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
				environment.Update(entities, playerIndex);
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
			
			if (playerIndex >= 0){
				UpdateView(entities[playerIndex]);
				UpdateMap(entities[playerIndex]);
			}
		}
		
		public function UpdateMap(avatar:Avatar):void
		{
			var avirb:Number = avatar.x+avatar.rb+avatar.vel.x;
			var avilb:Number = avatar.x+avatar.lb+avatar.vel.x;
			var avitb:Number = avatar.y+160;
			var avibb:Number = avatar.y+avatar.bb+160;
			var calcX:int = 240;
			var calcY:int = 320;
			
			var i:int;
			var spawnHeight:int = C_HEIGHT*3;
			if (baseY == GROUND_LEVEL) spawnHeight = C_HEIGHT*2;
			//FIRST HORIZONTAL			
			if (avirb > calcX+C_WIDTH && avatar.facing==Global.RIGHT){
				trace("RIGHT!");
				baseX+=C_WIDTH;
				if (baseX >= 2880) baseX -= 2880;
				//trace("baseX:"+baseX);
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, C_WIDTH, spawnHeight, 0, 0);
				MapGenerator.ShiftChunks(map, C_WIDTH, spawnHeight, C_WIDTH, 0, -C_WIDTH, 0);
				MapGenerator.ShiftChunks(map, C_WIDTH, spawnHeight, C_WIDTH*2, 0, -C_WIDTH, 0);
				ShiftEntities(-C_WIDTH, 0);
				EntitySpawner.Despawn(avatar, entities);
				for (i = 0; i < spawnHeight; i+=C_HEIGHT){
					MapGenerator.GenerateMap(baseX, baseY, map, C_WIDTH, C_HEIGHT, C_WIDTH*2, i);
					EntitySpawner.SpawnEntities(baseX, baseY, entities, map, C_WIDTH, C_HEIGHT, C_WIDTH*2, i, Global.RIGHT);
				}
				L_bitmap.x+=C_WIDTH;
			}else if (avilb < calcX && avatar.facing==Global.LEFT){
				trace("LEFT!");
				baseX-=C_WIDTH;
				if (baseX < 0) baseX += 2880;
				//trace("baseX:"+baseX);
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, C_WIDTH, spawnHeight, C_WIDTH*2, 0);
				MapGenerator.ShiftChunks(map, C_WIDTH*2, spawnHeight, 0, 0, C_WIDTH, 0);
				ShiftEntities(C_WIDTH, 0);
				EntitySpawner.Despawn(avatar, entities);
				for (i = 0; i < spawnHeight; i+=C_HEIGHT){
					MapGenerator.GenerateMap(baseX, baseY, map, C_WIDTH, C_HEIGHT, 0, i);
					EntitySpawner.SpawnEntities(baseX, baseY, entities, map, C_WIDTH, C_HEIGHT, 0, i, Global.LEFT);
				}
				L_bitmap.x-=C_WIDTH;
			}
			//NOW FOR VERTICAL
			else if (avibb > calcY+C_HEIGHT && avatar.vel.y > 1 && baseY != GROUND_LEVEL){
				trace("DOWN!");
				baseY+=C_HEIGHT;
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, C_WIDTH*3, C_HEIGHT, 0, 0);
				MapGenerator.ShiftChunks(map, C_WIDTH*3, C_HEIGHT, 0, C_HEIGHT, 0, -C_HEIGHT);
				MapGenerator.ShiftChunks(map, C_WIDTH*3, C_HEIGHT, 0, C_HEIGHT*2, 0, -C_HEIGHT);
				ShiftEntities(0, -C_HEIGHT);
				EntitySpawner.Despawn(avatar, entities);
				L_bitmap.y+=C_HEIGHT;
				
				spawnHeight = C_HEIGHT*2;
				if (baseY == GROUND_LEVEL) return;
				for (i = 0; i < 3; i++){
					MapGenerator.GenerateMap(baseX, baseY, map, C_WIDTH, C_HEIGHT, i*C_WIDTH, spawnHeight);
					EntitySpawner.SpawnEntities(baseX, baseY, entities, map, C_WIDTH, C_HEIGHT, i*C_WIDTH, spawnHeight, Global.DOWN);
				}
			}else if (avitb < calcY && avatar.on_ground){
				trace("UP!");
				baseY-=C_HEIGHT;
				TryToChangeScaleArray();
				MapGenerator.DeleteChunk(map, C_WIDTH*3, C_HEIGHT, 0, C_HEIGHT*2);
				MapGenerator.ShiftChunks(map, C_WIDTH*3, C_HEIGHT*2, 0, 0, 0, C_HEIGHT);
				ShiftEntities(0, C_HEIGHT);
				EntitySpawner.Despawn(avatar, entities);
				for (i = 0; i < 3; i++){
					MapGenerator.GenerateMap(baseX, baseY, map, C_WIDTH, C_HEIGHT, i*C_WIDTH, 0);
					EntitySpawner.SpawnEntities(baseX, baseY, entities, map, C_WIDTH, C_HEIGHT, i*C_WIDTH, 0, Global.UP);
				}
				L_bitmap.y-=C_HEIGHT;
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
			var avibb:Number = avatar.y+avatar.bb+32;
			var right:Number = Global.stageWidth-L_bitmap.x;
			var left:Number = 0-(L_bitmap.x);
			var top:Number = 0-(L_bitmap.y);
			var bottom:Number = Global.stageHeight-L_bitmap.y;

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

			if (baseY == GROUND_LEVEL && L_bitmap.y < -GROUND_LEVEL)
				L_bitmap.y = -GROUND_LEVEL;
			/*else if (L_bitmap.y < (L_bitmap.height-Global.stageHeight)*(-1))
				L_bitmap.y = (L_bitmap.height-Global.stageHeight)*(-1);
			if (L_bitmap.y > 0) L_bitmap.y = 0;*/
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
			//trace(Game._SiONArray);
		}
	}
}