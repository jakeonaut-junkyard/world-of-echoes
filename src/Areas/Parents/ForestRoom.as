package Areas.Parents 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldWorm;
	import Entities.Field.*;
	import LoaderManagers.SoundManager;
	
	public class ForestRoom extends Room
	{				
		[Embed(source = "../../resources/images/field/grassTileset.png")]
		private var my_tile_set:Class;
		
		public function ForestRoom(width:int, height:int, row:int, column:int)  
		{
			super(width, height, row, column);
			tile_set = my_tile_set;
			
			var i:int;
			for (i = 0; i < width/16; i++){
				map[height/16-2][i] = new Tile(i*16, height-32, i%4, 1);
			}
		}
		
		override public function EnterRoom():void
		{
			super.EnterRoom();
			SoundManager.getInstance().playSfx("CricketAmbience", -5, int.MAX_VALUE);
			
			CreateScaleArray(12, Global.DORIAN_MODE, 12, 48);
		}
	}
}