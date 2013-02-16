package Areas 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldWorm;
	import Areas.Parents.CaveRoom;
	
	public class Cave54 extends CaveRoom
	{		
		
		public function Cave54() 
		{
			//TODO:: ALWAYS CHECK THAT THE FINAL 2 INPUT PARAMETERS MATCH THE TWO DIGITS IN THE NAME OF THE ROOM!!!
			super(320, 240, 5, 4);
			
			var i:int;
			for (i = 0; i < height/16; i++){
				map[i][width/16-1] = new Tile((width-16), i*16, 1, 0, true);
				if (i < 2 || i > 6)
					map[i][width/16-2] = new Tile(width-32, i*16, 1, 0, true);
				if (i == 9 || i > 11)
					map[i][width/16-3] = new Tile(width-48, i*16, 1, 0, true);
			}
			for (i = 12; i < 18; i++){
				map[0][i] = new Tile(i*16, 0, 0, 0);
			}
			for (i = 0; i < 4; i++){
				map[5][12+i] = new Tile((12+i)*16, 5*16, 1, 0, true);
				if (i < 2){
					map[4][12+i] = new Tile((12+i)*16, 4*16, 1, 0, true);
					map[6][13+i] = new Tile((13+i)*16, 6*16, 1, 0, true);
				}
			}
			
			entities.push(new GoldWorm(100, height-64));
		}
	}
}