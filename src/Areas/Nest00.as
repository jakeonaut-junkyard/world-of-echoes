package Areas 
{
	import Entities.Avatar;
	import Entities.Door;
	import Entities.Tile;
	import Entities.GoldBugs.*;
	import Entities.Field.*;
	import LoaderManagers.SoundManager;
	
	public class Nest00 extends Room
	{				
		[Embed(source = "../resources/images/field/grassTileset.png")]
		private var my_tile_set:Class;
		
		public function Nest00() 
		{
			super(208, 160, 0, 0, 0, 213);
			tile_set = my_tile_set;
			
			var i:int;
			for (i = 0; i < height/16; i++){
				for (var j:int = 0; j <= width/16; j++){
					if (i == 0 || j == 0) 
						map[i][j] = new Tile(j*16, i*16, 1, 0, true);
					else if (j > 0 && j <= width/16)
						map[height/16-2][j] = new Tile(j*16, height-32, (j+1)%4, 1);
				}
			}
			
			entities.push(new Avatar(32, height-33, 1));
			playerIndex = entities.length-1;entities.push(new GoldWorm(180, height-37));
			entities.push(new Door(width, 0, 0, 0, 32, height, 1));
			
		}
		
		override public function EnterRoom():void
		{
			super.EnterRoom();
			
			CreateScaleArray(12, Global.IONIAN_MODE, 12, 48);
		}
	}
}