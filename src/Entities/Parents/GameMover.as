package Entities.Parents 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jake Trower
	 */
	public class GameMover extends GameSprite 
	{
		public var vel:Point;
		
		public function GameMover(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			vel = new Point(0, 0);
		}
		
		public function UpdateMovement(entities:Array, map:Array):void
		{
			var i:int;
			var solids:Array = [];
			for (i = 0; i < entities.length; i++){
				if (entities[i].solid) solids.push(entities[i]);
			}for (i = 0; i < map.length; i++){
				for (var j:int = 0; j < map[i].length; j++){
					if (map[i][j].solid) solids.push(map[i][j]);
				}
			}
			
			//Update movement			
			//check for solid collisions
			if (solids.length > 0)
			{
				CollideWithSolids(solids)
			}
			else{
				x += (vel.x*Global.CURR_PHYSICS_SPEED);
				y += (vel.y*Global.CURR_PHYSICS_SPEED);
			}
		}
		
		public function CollideWithSolids(solids:Array):void
		{
			var i:int;
			for (i = 0; i < solids.length; i++)
			{
				//horizontal solid collisions (LEFT)
				if (CheckRectIntersect(solids[i], x+lb+vel.x-1, y+tb, x+lb, y+bb))
				{
					vel.x = 0;
					while (!CheckRectIntersect(solids[i], x+lb-1, y+tb, x+lb, y+bb))
						x--;
				}
				//horizontal solid collisions (RIGHT)
				if (CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+vel.x+1, y+bb))
				{
					vel.x = 0;
					while (!CheckRectIntersect(solids[i], x+rb, y+tb, x+rb+1, y+bb))
						x++;
				}
			}
			x += (vel.x*Global.CURR_PHYSICS_SPEED);
				
			for (i = 0; i < solids.length; i++)
			{
				//vertical solid collisions (TOP)
				if (CheckRectIntersect(solids[i], x+lb, y+tb+vel.y-1, x+rb, y+tb))
				{
					vel.y = 0;
					while (!CheckRectIntersect(solids[i], x+lb, y+tb-1, x+rb, y+tb))
						y--;
				}
				//vertical solid collisions (BOTTOM)
				if (CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+vel.y+1))
				{
					vel.y = 0;
					while (!CheckRectIntersect(solids[i], x+lb, y+bb, x+rb, y+bb+1))
						y++;
				}
			}
			y += (vel.y*Global.CURR_PHYSICS_SPEED);
		}
	}
}