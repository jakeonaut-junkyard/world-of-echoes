package Entities.Parents 
{
	public class GameFaller extends GameMover
	{
		public var grav_acc:Number;
		public var terminal_vel:Number;
		public var on_ground:Boolean;
		public var hit_head:Number;
		
		public var antigrav:Boolean = false;
		
		public function GameFaller(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int)
		{
			super(x, y, lb, tb, rb, bb);
			
			grav_acc = 1;
			terminal_vel = 6;
			on_ground = false;
			hit_head = 0;
		}
		
		public function Gravity():void
		{
			if (antigrav)
				return;
				
			if (vel.y < terminal_vel)
			{
				vel.y += (grav_acc*Global.CURR_PHYSICS_SPEED);
			}
			else
				vel.y = terminal_vel;
		}
		
		override public function CollideWithSolids(solids:Array):void
		{
			var i:int;
			for (i = 0; i < solids.length; i++)
			{
				//horizontal solid collisions (LEFT)
				if (CheckRectIntersect(solids[i], x+lb+vel.x, y+tb, x+lb, y+bb))
				{
					vel.x = 0;
					while (!CheckRectIntersect(solids[i], x+lb-1, y+tb, x+lb, y+bb))
						x--;
				}
				//horizontal solid collisions (RIGHT)
				if (CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+vel.x, y+bb))
				{
					vel.x = 0;
					while (!CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+1, y+bb))
						x++;
				}
			}
			x += (vel.x*Global.CURR_PHYSICS_SPEED);
			
			on_ground = false;
			for (i = 0; i < solids.length; i++)
			{
				//vertical solid collisions (TOP)
				if (CheckRectIntersect(solids[i], x+lb, y+tb+vel.y, x+rb, y+tb))
				{
					vel.y = 0;
					hit_head = 3;
					while (!CheckRectIntersect(solids[i], x+lb, y+tb-1, x+rb, y+tb))
						y--;
				}
				//vertical solid collisions (BOTTOM)
				if (CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+vel.y+1))
				{
					vel.y = 0;
					on_ground = true;
					while (!CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+1))
						y++;
				}
			}
			y += (vel.y*Global.CURR_PHYSICS_SPEED);
			
			if (hit_head > 0) (hit_head-=Global.CURR_PHYSICS_SPEED);
		}
	}
}