package LoaderManagers 
{
	public class AmbientSoundLoader 
	{
		[Embed(source = "../resources/sounds/cricketNight.mp3")]
		private var Cricket_Ambience:Class;
		[Embed(source = "../resources/sounds/LA_Shore_Long.mp3")]
		private var Shore_Ambience:Class;
		[Embed(source = "../resources/sounds/OOT_ChamberOfSages_BG.mp3")]
		private var Cave_Ambience:Class;
		
		public function AmbientSoundLoader() 
		{
			SoundManager.getInstance().addSfx(new Cricket_Ambience(), "CricketAmbience");
			SoundManager.getInstance().Ambient_Sounds.push("CricketAmbience");
			
			SoundManager.getInstance().addSfx(new Shore_Ambience(), "ShoreAmbience");
			SoundManager.getInstance().Ambient_Sounds.push("ShoreAmbience");
			
			SoundManager.getInstance().addSfx(new Cave_Ambience(), "CaveAmbience");
			SoundManager.getInstance().Ambient_Sounds.push("CaveAmbience");
		}		
	}
}