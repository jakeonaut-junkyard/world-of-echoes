package  
{
	import Entities.Avatar;
	
	public class PlayerInputManager 
	{
		
		public function PlayerInputManager() 
		{
		}
		
		public static function PlayerInput(avatar:Avatar):void
		{
			//CONTROL AVATAR JUMPING
			if (Global.CheckKeyPressed(Global.UP)){
				if (avatar.on_ground){
					avatar.on_ground = false;
					avatar.vel.y = -avatar.jump_vel;
				}
			}
			/*if (avatar.hit_head == 0){
				if (Global.CheckKeyDown(Global.UP) && !avatar.on_ground){
					avatar.y-=2;
					if (avatar.vel.y > 0) avatar.y-=1;
				}
			}*/
			else if (avatar.hit_head >= 2){ 
				avatar.y += 2;
				avatar.vel.y = 0;
			}
			//CONTROL AVATAR RUNNING
			if (Global.CheckKeyDown(Global.RIGHT)){
				avatar.vel.x = avatar.top_xspeed;
				avatar.facing = Global.RIGHT;
				if (avatar.on_ground)
					avatar.move_state = avatar.RUNNING;
			}else if (Global.CheckKeyDown(Global.LEFT)){
				avatar.vel.x = -avatar.top_xspeed;
				avatar.facing = Global.LEFT;
				if (avatar.on_ground)
					avatar.move_state = avatar.RUNNING;
			}else{
				avatar.vel.x = 0;
				avatar.move_state = avatar.STANDING;
			}
		}		
	}
}