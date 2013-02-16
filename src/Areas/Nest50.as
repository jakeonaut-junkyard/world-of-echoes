package Areas 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldWorm;
	import Entities.Field.*;
	import Areas.Parents.ForestRoom;
	import LoaderManagers.SoundManager;
	
	public class Nest50 extends ForestRoom
	{				
		public function Nest50() 
		{
			//TODO:: ALWAYS CHECK THAT THE FINAL 2 INPUT PARAMETERS MATCH THE TWO DIGITS IN THE NAME OF THE ROOM!!!
			super(320, 240, 5, 0);
			
			var i:int;
			for (i = 0; i < height/16; i++){
				for (var j:int = 0; j <= width/16; j++){
					if (i == 0 || j == 0) 
						map[i][j] = new Tile(j*16, i*16, 1, 0, true);
				}
			}
		}
	}
}