package Areas 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldWorm;
	import Entities.Field.*;
	import Areas.Parents.ForestRoom;
	import LoaderManagers.SoundManager;
	
	public class BigTreeField01 extends ForestRoom
	{		
		public function BigTreeField01() 
		{
			//TODO:: ALWAYS CHECK THAT THE FINAL 2 INPUT PARAMETERS MATCH THE TWO DIGITS IN THE NAME OF THE ROOM!!!
			super(320, 240, 0, 1);
			
			for (var i:int = 0; i < 10; i++){
				entities.push(new Butterfly(64+i*10, height-33));
			}entities.push(new GoldWorm(200, height-37));
		}
	}
}