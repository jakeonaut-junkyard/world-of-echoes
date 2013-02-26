package Entities.Parents 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.utils.*;
	
	public class GameMover extends GameSprite 
	{
		public var vel:Point;
		public var facing:int;
		
		public function GameMover(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			vel = new Point(0, 0);
			facing = Global.RIGHT;
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			super.DrawSpriteFromSheet(temp_image, temp_sheet);
			
			//RENDER IT
			var matrix:Matrix = new Matrix();
			if (facing == Global.LEFT)
			{
				matrix.scale(-1, 1);
				matrix.translate(frameWidth, 0);
			}
			matrix.translate(int(x), int(y));
			levelRenderer.draw(image_sprite, matrix);
		}
		
		public function UpdateMovement(entities:Array, map:Dictionary):void
		{
			var i:int;
			var solids:Array = [];
			for (i = 0; i < entities.length; i++){
				if (entities[i].solid) solids.push(entities[i]);
				else if (entities[i].topDownSolid && !Global.CheckKeyDown(Global.DOWN)){
					if (y+bb < entities[i].y+entities[i].tb)
						solids.push(entities[i]);
				}
			}
			for each (var tile:GameObject in map){
				if (tile.solid) solids.push(tile);
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