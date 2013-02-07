package Entities 
{
	import Entities.Parents.GameObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Door extends GameObject
	{
		public var nextRoomId:int;
		
		public function Door(x:int, y:int, lb:int, tb:int, rb:int, bb:int, id:int)
		{
			super(x, y, lb, tb, rb, bb);
			this.nextRoomId = id;
			solid = false;
		}
		
		public function Update(entities:Array, map:Array):void
		{
			for (var i:int = 0; i < entities.length; i++){
				if (entities[i] is Avatar){
					if (CheckRectIntersect(entities[i], x+lb, y+tb, x+rb, y+bb)){
						Game.roomArray[nextRoomId].EnterRoom();
						Game.roomIndex = nextRoomId;
					}
					return;
				}
			}
		}
		
		public function Render(levelRenderer:BitmapData):void
		{
			return;
		}
	}
}