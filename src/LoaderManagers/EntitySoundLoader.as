package LoaderManagers 
{
	public class EntitySoundLoader 
	{
		[Embed(source = '../resources/sounds/insect.mp3')]
		public var insect_sound:Class;
		
		public function EntitySoundLoader() 
		{
			SoundManager.getInstance().addSfx(new insect_sound(), "InsectSound");
		}		
	}
}