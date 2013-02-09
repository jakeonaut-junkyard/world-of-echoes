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
	
	public class CaveRoom extends Room
	{		
		[Embed(source = "../../resources/images/cave/tileset.png")]
		private var my_tile_set:Class;
		
		public function CaveRoom(width:int, height:int, row:int, column:int) 
		{
			super(width, height, row, column);
			tile_set = my_tile_set;
		}
		
		override public function EnterRoom():void
		{
			super.EnterRoom();			
			SoundManager.getInstance().playSfx("CaveAmbience", -5, int.MAX_VALUE);
			
			CreateScaleArray(12, Global.PHRYGIAN_MODE, 12, 48);
		}
	}
}