package Areas 
{
	import Entities.Avatar;
	import Entities.Door;
	import Entities.Tile;
	import Entities.GoldBugs.*;
	import Entities.Field.*;
	import LoaderManagers.SoundManager;
	
	public class BigTreeField01 extends Room
	{		
		[Embed(source = "../resources/sounds/cricketNight.mp3")]
		private var Cricket_Ambience:Class;
		[Embed(source = "../resources/sounds/fieldAmbience.mp3")]
		private var Field_Ambience:Class;
		
		[Embed(source = "../resources/images/field/grassTileset.png")]
		private var my_tile_set:Class;
		
		public function BigTreeField01() 
		{
			super(320, 240, 1, 224, 0);
			tile_set = my_tile_set;
			
			var i:int;
			for (i = 0; i < width/16; i++){
				map[height/16-2][i] = new Tile(i*16, height-32, i%4, 1);
			}for (i = 0; i <= (height-160)/16; i++){
				map[i][0] = new Tile(0, i*16, 1, 0, true);
			}
			
			entities.push(new Avatar(0, height-33, 1));
			playerIndex = entities.length-1;
			entities.push(new Door(-32, height-160, 0, 0, 32, 160, 0));
			entities.push(new Door(width, height-160, 0, 0, 32, 160, 2));
			for (i = 0; i < 10; i++){
				entities.push(new Butterfly(64+i*10, height-33));
			}entities.push(new GoldWorm(200, height-37));
			
			SoundManager.getInstance().addSfx(new Field_Ambience(), "FieldAmbience");
			SoundManager.getInstance().addSfx(new Cricket_Ambience(), "CricketAmbience");
			SoundManager.getInstance().Ambient_Sounds.push("FieldAmbience");
			SoundManager.getInstance().Ambient_Sounds.push("CricketAmbience");
		}
		
		override public function EnterRoom():void
		{
			super.EnterRoom();
			//SoundManager.getInstance().playSfx("FieldAmbience", -5, int.MAX_VALUE);
			SoundManager.getInstance().playSfx("CricketAmbience", -5, int.MAX_VALUE);
			
			CreateScaleArray(12, Global.IONIAN_MODE, 12, 48);
		}
	}
}