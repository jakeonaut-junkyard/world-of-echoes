package Entities.GoldBugs 
{
	import Entities.Avatar;
	import Entities.Parents.GameMover;
	import LoaderManagers.SoundManager;
	
	public class GoldWorm extends GameMover
	{
		[Embed(source = "../../resources/images/gold_worm_sheet.png")]
		private var my_sprite_sheet:Class;
		private var twinkle:int;
		
		public function GoldWorm(x:int, y:int)
		{
			super(x, y, 0, 0, 6, 6);
			
			sprite_sheet = my_sprite_sheet;
			frameWidth = 6;
			frameHeight = 6;
			frameDelay = 8;
			maxFrame = 2;
			twinkle = 3;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			if (delete_me) return;
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb)){
						SoundManager.getInstance().playSfx("InsectSound", 0, 1);
						delete_me = true;
						visible = true;
						Global.MAX_WINGFLAPS++;
					}
					break;
				}
			}
			
			twinkle--;
			if (twinkle <= 0){
				var rx:int = Math.floor(Math.random()*7)-3;
				var ry:int = Math.floor(Math.random()*7)-3;
				entities.push(new GoldTwinkle(x+rx, y+ry));
				twinkle = 3;
			}
			
			UpdateMovement(entities, map);
			UpdateAnimation();
			
			if (currFrame == 1){
				vel.x = 1;
			}else{
				vel.x = 0;
			}
		}
	}
}