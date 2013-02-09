package Areas.Parents 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldWorm;
	import Entities.Beach.Wave;
	import LoaderManagers.SoundManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class BeachRoom extends Room
	{		
		[Embed(source = "../../resources/images/beach/tileset.png")]
		private var my_tile_set:Class;
		
		public function BeachRoom(width:int, height:int, row:int, column:int) 
		{
			super(width, height, row, column);
			tile_set = my_tile_set;
			
			var i:int;
			for (i = 0; i < 2; i++){
				map[13][i+4] = new Tile((i+4)*16, 13*16, 1, 0, true, 1);
				map[13][i+6] = new Tile((i+6)*16, 13*16, 1, 0, true, 2);
				map[13][i+9] = new Tile((i+9)*16, 13*16, 1, 0, true, 4);
				map[13][i+11] = new Tile((i+11)*16, 13*16, 1, 0, true, 4);
				map[13][i+13] = new Tile((i+13)*16, 13*16, 1, 0, true, 3);
				map[13][i+16] = new Tile((i+16)*16, 13*16, 1, 0, true, 1);
			}
			map[13][8] = new Tile((8*16), 13*16, 1, 0, true, 3);
			map[13][15] = new Tile(15*16, 13*16, 1, 0, true, 2);
			
			for (i = 0; i < width/16; i++){
				entities.push(new Wave(i*16, height-16, i%6));
			}
		}
		
		override public function EnterRoom():void
		{
			super.EnterRoom();			
			SoundManager.getInstance().playSfx("ShoreAmbience", -5, int.MAX_VALUE);
			
			CreateScaleArray(12, Global.IONIAN_MODE, 12, 48);
		}
		
		override public function Render():void
		{
			LevelRenderer.lock();
			LevelRenderer.fillRect(new Rectangle(0, 0, LevelRenderer.width, LevelRenderer.height), 0x000000);//0xFD7A1C);
			
			var i:int, j:int;
			var tile_sheet:Bitmap = new tile_set();
			var foreground:Array = [];
			playerIndex = -1;
			for (i = 0; i < map.length; i++){
				for (j = 0; j < map[i].length; j++){
					if (map[i][j].solid) DrawMapPiece(map[i][j], tile_sheet);
					else if (map[i][j].tileset_x != 0 || map[i][j].tileset_y != 0)
						foreground.push(map[i][j]);
				}
			}for (i = entities.length-1; i >= 0; i--){
				if (entities[i] is Avatar) playerIndex = i;
				else entities[i].Render(LevelRenderer);
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
	}
}