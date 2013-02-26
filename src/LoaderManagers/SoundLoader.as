package LoaderManagers 
{
	public class SoundLoader 
	{
		[Embed(source = '../resources/sounds/LA_Seagull.mp3')]
		public var seagull_sound:Class;
		[Embed(source = '../resources/sounds/insect.mp3')]
		public var insect_sound:Class;
		
		[Embed(source = "../resources/sounds/LA_Shore_Long.mp3")]
		private var Shore_Ambience:Class;
		[Embed(source = "../resources/sounds/OOT_Rain.mp3")]
		private var Rain_Ambience:Class;
		[Embed(source = "../resources/sounds/OOT_Night_Cicada1.mp3")]
		private var Cicada1_Ambience:Class;
		[Embed(source = "../resources/sounds/OOT_Night_Cicada2.mp3")]
		private var Cicada2_Ambience:Class;
		[Embed(source = "../resources/sounds/OOT_Night_Cicada3.mp3")]
		private var Cicada3_Ambience:Class;
		[Embed(source = "../resources/sounds/OOT_Night_Cicada1_Die.mp3")]
		private var Cicada1_Death:Class;
		[Embed(source = "../resources/sounds/OOT_Night_Cicada2_Die.mp3")]
		private var Cicada2_Death:Class;
		[Embed(source = "../resources/sounds/OOT_Night_Cicada3_Die.mp3")]
		private var Cicada3_Death:Class;
		
		[Embed(source = "../resources/sounds/birdFlapAway.mp3")]
		private var BirdFlap_Sound:Class;
		[Embed(source = "../resources/sounds/OOT_Morning_BirdCheep1.mp3")]
		private var BirdCheep1_Sound:Class;
		[Embed(source = "../resources/sounds/OOT_Morning_BirdCheep2.mp3")]
		private var BirdCheep2_Sound:Class;
		[Embed(source = "../resources/sounds/OOT_Morning_BirdCheep3.mp3")]
		private var BirdCheep3_Sound:Class;
		[Embed(source = "../resources/sounds/OOT_Morning_BirdChirp1.mp3")]
		private var BirdChirp1_Sound:Class;
		[Embed(source = "../resources/sounds/OOT_Morning_BirdChirp2.mp3")]
		private var BirdChirp2_Sound:Class;
		[Embed(source = "../resources/sounds/OOT_Morning_BirdChirp3.mp3")]
		private var BirdChirp3_Sound:Class;
		
		public function SoundLoader() 
		{
			SoundManager.getInstance().addSfx(new seagull_sound(), "SeagullSound");
			SoundManager.getInstance().addSfx(new insect_sound(), "InsectSound");
			
			SoundManager.getInstance().addSfx(new Shore_Ambience(), "ShoreAmbience");
			SoundManager.getInstance().addSfx(new Rain_Ambience(), "RainAmbience");
			SoundManager.getInstance().addSfx(new Cicada1_Ambience(), "Cicada1Ambience");
			SoundManager.getInstance().addSfx(new Cicada2_Ambience(), "Cicada2Ambience");
			SoundManager.getInstance().addSfx(new Cicada3_Ambience(), "Cicada3Ambience");
			SoundManager.getInstance().addSfx(new Cicada1_Death(), "Cicada1Death");
			SoundManager.getInstance().addSfx(new Cicada2_Death(), "Cicada2Death");
			SoundManager.getInstance().addSfx(new Cicada3_Death(), "Cicada3Death");
			
			SoundManager.getInstance().addSfx(new BirdFlap_Sound(), "BirdFlapSound");
			SoundManager.getInstance().addSfx(new BirdCheep1_Sound(), "BirdCheep1Sound");
			SoundManager.getInstance().addSfx(new BirdCheep2_Sound(), "BirdCheep2Sound");
			SoundManager.getInstance().addSfx(new BirdCheep3_Sound(), "BirdCheep3Sound");
			SoundManager.getInstance().addSfx(new BirdChirp1_Sound(), "BirdChirp1Sound");
			SoundManager.getInstance().addSfx(new BirdChirp2_Sound(), "BirdChirp2Sound");
			SoundManager.getInstance().addSfx(new BirdChirp3_Sound(), "BirdChirp3Sound");
		}		
	}
}