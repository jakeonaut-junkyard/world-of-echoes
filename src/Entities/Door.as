package Entities 
{
	public class Door extends GameObject
	{
		public var to_avix:int;
		public var to_aviy:int;
		public var to_roomIndex:int;
		
		public function Door(avix:int, aviy:int, roomIndex:int, x:int, y:int, lb:int, tb:int, rb:int, bb:int) 
		{
			super(x, y, lb, tb, rb, bb);
			to_avix = avix;
			to_aviy = aviy;
			to_roomIndex = roomIndex;
		}		
		
		public function Update(avatar:Avatar):void
		{
			if (CheckRectIntersect(avatar, x+lb, y+tb, x+rb, y+bb))
			{
				Game.areas[to_roomIndex].EnterRoom(avatar, to_avix, to_aviy);
				Game.areaIndex = to_roomIndex;
			}
		}
	}
}