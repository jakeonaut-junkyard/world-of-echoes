package LoaderManagers 
{
	public class EntitySoundLoader 
	{
		[Embed(source = '../resources/sounds/LA_Seagull.mp3')]
		public var seagull_sound:Class;
		[Embed(source = '../resources/sounds/insect.mp3')]
		public var insect_sound:Class;
		
		public function EntitySoundLoader() 
		{
			SoundManager.getInstance().addSfx(new seagull_sound(), "SeagullSound");
			SoundManager.getInstance().addSfx(new insect_sound(), "InsectSound");
		}		
	}
}