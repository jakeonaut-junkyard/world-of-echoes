package Entities.Beach 
{
	import Entities.Parents.GameSprite;
	import flash.utils.*;
	
	public class Wave extends GameSprite
	{
		[Embed(source = "../../resources/images/beach/wave_sheet.png")]
		private var my_sprite_sheet:Class;
		
		public function Wave(x:int, y:int, currFrame:int)
		{
			super(x, y, 0, 0, 16, 16);
			sprite_sheet = my_sprite_sheet;
			
			maxFrame = 6;
			frameWidth = 16;
			frameHeight = 16;
			frameDelay = 6;
			this.currFrame = currFrame;
			visible = true;
		}		
		
		override public function Update(entities:Array, map:Dictionary):void
		{		
			if (currFrame == 2 || currFrame == 5) frameDelay = 12;
			else if (currFrame == 0 || currFrame == 4) frameDelay = 2;
			else frameDelay = 7;
			UpdateAnimation();
		}
	}
}