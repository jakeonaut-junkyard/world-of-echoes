package Areas 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldWorm;
	import Entities.Beach.*;
	import Areas.Parents.BeachRoom;
	
	public class RockyBeach52 extends BeachRoom
	{		
		
		public function RockyBeach52() 
		{
			//TODO:: ALWAYS CHECK THAT THE FINAL 2 INPUT PARAMETERS MATCH THE TWO DIGITS IN THE NAME OF THE ROOM!!!
			super(320, 240, 5, 2);
			
			entities.push(new GoldWorm(100, height-64));
			entities.push(new Seagull(50, height-96));
			entities.push(new Seagull(75, height-128));
		}
	}
}