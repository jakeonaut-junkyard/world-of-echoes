package Entities 
{
	/**
	 * ...
	 * @author Jake Trower
	 */
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
		
		public function GameObject(x:Number, y:Number, lb:int, tb:int, rb:int, bb:int) 
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
		}
	}
}