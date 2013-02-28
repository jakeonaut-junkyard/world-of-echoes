package Entities.Environment 
{
	import Entities.Parents.GameSprite;
	import LoaderManagers.EnvironmentManager;
	import flash.utils.*;
	
	public class Tree extends GameSprite
	{
		[Embed(source = "../../resources/images/tree_sheet.png")]
		private var my_sprite_sheet:Class;
		
		private var glitchTimer:int = 0;
		private var glitched:Boolean = false;
		public static const TREE_TRACKID:int = 101;
		
		public function Tree(x:int, y:int) 
		{
			super(x, y, 0, 0, 48, 80);
			sprite_sheet = my_sprite_sheet;
			currAniX = 0;
			
			frameWidth = 48;
			frameHeight = 80;
			topDownSolid = true;
		}
		
		override public function Update(entities:Array, map:Dictionary):void
		{
			glitchTimer--;
			if (glitchTimer <= 0){
				if (glitched){
					currAniX = 0;
					glitchTimer = Math.floor(Math.random()*50)+100;
				}else{
					if (Math.floor(Math.random()*4) <= 0){
						glitched = true;
						currAniX = 1
						glitchTimer = 2;
						
						var rand:int = Math.floor(Math.random()*EnvironmentManager.treeVoice.noteArray.length);
						Game._driver.noteOff(EnvironmentManager.treeVoice.noteArray[rand], TREE_TRACKID);
						Game._driver.noteOn(EnvironmentManager.treeVoice.noteArray[rand], EnvironmentManager.treeVoice.voice, 2, 0, 0, TREE_TRACKID);
					}
				}
				glitched = !glitched;
			}
		}
	}
}