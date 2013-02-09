package Areas 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldWorm;
	import Areas.Parents.BeachRoom;
	
	public class Beach03 extends BeachRoom
	{		
		
		public function Beach03() 
		{
			//TODO:: ALWAYS CHECK THAT THE FINAL 2 INPUT PARAMETERS MATCH THE TWO DIGITS IN THE NAME OF THE ROOM!!!
			super(320, 240, 0, 3);
			
			entities.push(new GoldWorm(100, height-64));
		}
	}
}