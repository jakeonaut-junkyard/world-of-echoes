package Entities.Forest 
{
	import Entities.Parents.GameSprite;
	import flash.utils.*;
	
	public class Tree extends GameSprite
	{
		[Embed(source = "../../resources/images/tree_sheet.png")]
		private var my_sprite_sheet:Class;
		
		private var trySpawnCicadas:Boolean = true;
		
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
		}
	}
}