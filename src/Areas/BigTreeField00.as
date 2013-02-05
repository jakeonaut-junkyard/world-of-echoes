package Areas 
{
	import Entities.Avatar;
	import Entities.Tile;
	import Entities.GoldBugs.*;
	import Entities.Field.*;
	import LoaderManagers.SoundManager;
	
	public class BigTreeField00 extends Room
	{		
		[Embed(source = "../resources/sounds/cricketNight.mp3")]
		private var Cricket_Ambience:Class;
		[Embed(source = "../resources/sounds/fieldAmbience.mp3")]
		private var Field_Ambience:Class;
		
		public function BigTreeField00() 
		{
			super(320, 240, 0);
			
			var i:int;
			//ADD MORE SOLIDs
			/*for (i = 0; i < 2; i++){
				map[8][4+i] = new Tile((4+i)*16, 8*16, 1, 0, true);
				map[7][7+i] = new Tile((7+i)*16, 7*16, 1, 0, true);
				map[5][9+i] = new Tile((9+i)*16, 5*16, 1, 0, true);
				map[3][7+i] = new Tile((7+i)*16, 3*16, 1, 0, true);
				map[3][3+i] = new Tile((3+i)*16, 3*16, 1, 0, true);
			}*/
			
			entities.push(new Avatar(32, height-33, 1));
			playerIndex = entities.length-1;
			for (i = 0; i < 10; i++){
				entities.push(new Butterfly(64+i*10, height-33));
			}entities.push(new GoldWorm(200, height-23));
			
			SoundManager.getInstance().addSfx(new Field_Ambience(), "FieldAmbience");
			SoundManager.getInstance().addSfx(new Cricket_Ambience(), "CricketAmbience");
		}
		
		override public function EnterRoom():void
		{
			SoundManager.getInstance().stopAllSfx();
			SoundManager.getInstance().playSfx("FieldAmbience", -5, int.MAX_VALUE);
			SoundManager.getInstance().playSfx("CricketAmbience", -5, int.MAX_VALUE);
			
			CreateScaleArray(12, Global.IONIAN_MODE, 12, 48);
		}
	}
}