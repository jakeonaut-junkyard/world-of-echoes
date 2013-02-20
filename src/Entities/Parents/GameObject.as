package Entities.Parents 
{
	import flash.utils.*;
	 
	public class GameObject 
	{
		public var x:Number;
		public var y:Number;
		
		//interaction variables
		public var lb:int;
		public var tb:int;
		public var rb:int;
		public var bb:int;
		public var solid:Boolean;
		public var topDownSolid:Boolean;
		public var delete_me:Boolean;
		public var isDisposable:Boolean;
		
		public function GameObject(x:Number, y:Number, lb:int = 0, tb:int = 0, rb:int = 16, bb:int = 16) 
		{
			//basic collision/placement stuff
			this.x = x;
			this.y = y;
			this.lb = lb;
			this.tb = tb;
			this.rb = rb;
			this.bb = bb;
			
			//assume the object is solid at first (this will be the class used by room borders
			solid = true;
			topDownSolid = false;
			delete_me = false;
			isDisposable = false;
		}
		
		public function Update(entities:Array, map:Dictionary):void
		{
		}
		
		public function CheckRectIntersect(obj2:GameObject, lb:int, 
			tb:int, rb:int, bb:int):Boolean
		{			
			if (lb <= (obj2.x + obj2.rb) && rb >= (obj2.x + obj2.lb) &&
				tb <= (obj2.y + obj2.bb) && bb >= (obj2.y + obj2.tb))
			{
				return true;
			}
			return false;
		}
	}
}