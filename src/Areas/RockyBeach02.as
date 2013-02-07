package Areas 
{
	import Entities.Avatar;
	import Entities.Door;
	import Entities.Tile;
	import Entities.GoldBugs.*;
	import Entities.Field.*;
	import LoaderManagers.SoundManager;
	
	public class RockyBeach02 extends Room
	{		
		[Embed(source = "../resources/images/tileset.png")]
		private var my_tile_set:Class;
		
		public function RockyBeach02() 
		{
			super(320, 160, 2, 544, 0);
			tile_set = my_tile_set;
			
			var i:int;
			for (i = 0; i < height/16; i++){
				map[i][width/16-1] = new Tile((width-16), i*16, 1, 0, true);
			}
			
			entities.push(new Avatar(0, height-33, 1));
			playerIndex = entities.length-1;
			entities.push(new Door(-32, 0, 0, 0, 32, height, 1));
			entities.push(new GoldWorm(100, height-64));
		}
		
		override public function EnterRoom():void
		{
			super.EnterRoom();			
			CreateScaleArray(12, Global.DORIAN_MODE, 12, 48);
		}
	}
}