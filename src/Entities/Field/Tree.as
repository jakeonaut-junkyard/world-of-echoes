package Entities.Field 
{
	import Entities.Parents.GameSprite;
	
	public class Tree extends GameSprite
	{
		[Embed(source = "../../resources/images/tree_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function Tree(x:int, y:int) 
		{
			super(x, y, 0, 0, 48, 80);
			sprite_sheet = my_sprite_sheet;
			
			frameWidth = 48;
			frameHeight = 80;
			topDownSolid = true;
		}
	}
}