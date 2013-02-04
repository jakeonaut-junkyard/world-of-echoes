package Entities 
{
	import Entities.Parents.GameObject;

	public class Tile extends GameObject
	{
		public var tileset_x:int;
		public var tileset_y:int;

		public function Tile(x:int, y:int, tileset_x:int, tileset_y:int, solid:Boolean = false) 
		{
			super(x, y, 0, 0, 16, 16);
			this.tileset_x = tileset_x;
			this.tileset_y = tileset_y;
			this.solid = solid;
		}		
	}
}