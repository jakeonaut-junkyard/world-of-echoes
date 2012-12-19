package Entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class BassBurst
	{
		private const INITIAL_RADIUS:int = 8;
		private const MAX_RADIUS:int = 200;
		private const INITIAL_SPEED:int = 1;
		private const ACCELERATION:Number = 0.5;
		private const MAX_SPEED:int = 10;
		private const MAX_BURSTS:int = 5;
		private const COUNTER_LIMIT:int = 3;
		
		public var x:Number;
		public var y:Number;
		public var radii:Array;
		
		private var numBursts:int;
		private var newBurstCounter:int;
		private var polarity:Boolean = true;
		
		public var visible:Boolean;
		public var color:ColorTransform;
		
		public function BassBurst(x:int, y:int, color:ColorTransform) 
		{
			this.x = x;
			this.y = y;
			visible = true;
			
			numBursts = 1;
			newBurstCounter = 0;
			
			this.color = new ColorTransform();
			this.color.redMultiplier = color.redMultiplier;
			this.color.blueMultiplier = color.blueMultiplier;
			this.color.greenMultiplier = color.greenMultiplier;
			
			radii = [[INITIAL_RADIUS, INITIAL_SPEED, 1, 0, SquareColor()]];
		}
		
		public function Render(levelRenderer:BitmapData):void
		{
			if (!visible) return;
			
			for (var i:int = 0; i < radii.length; i++)
			{
				var newx:int = -(radii[i][0]);
				var newy:int = -(radii[i][0]);
				var width:int = (radii[i][0])*2;
				var height:int = (radii[i][0])*2;
				
				var my_shape:Shape = new Shape();
				my_shape.graphics.lineStyle(1, 0xFFFFFF, 1);
				my_shape.graphics.drawRect(newx, newy, width, height);
				
				radii[i][4].alphaMultiplier = radii[i][2];
				var matrix:Matrix = new Matrix();
				matrix.rotate(radii[i][3]);
				matrix.translate(x, y);
				levelRenderer.draw(my_shape, matrix, radii[i][4]);
			}
		}
		
		public function Update():void
		{
			for (var i:int = radii.length-1; i >= 0; i--)
			{
				radii[i][0]+=radii[i][1];
				if (radii[i][0] > MAX_RADIUS)
					radii.splice(i,1);
				else
				{
					if (radii[i][1] <= MAX_SPEED)
						radii[i][1]+= ACCELERATION;
					else
						radii[i][1] = MAX_SPEED;
					radii[i][2] -= 0.03;
					radii[i][3] += 0.2;
				}
			}
			
			if (numBursts < MAX_BURSTS)
			{
				newBurstCounter++;
				if (newBurstCounter >= COUNTER_LIMIT)
				{
					newBurstCounter = 0;
					numBursts++;
					radii.push([INITIAL_RADIUS, INITIAL_SPEED, 1, 0, SquareColor()]);
				}
			}
			else
			{
				if (radii.length <= 0)
				{
					visible = false;
				}
			}
		}
		
		public function SquareColor():ColorTransform
		{
			var newColor:ColorTransform = new ColorTransform();
			if (polarity)
			{
				newColor.redMultiplier = color.redMultiplier;
				newColor.greenMultiplier = color.greenMultiplier;
				newColor.blueMultiplier = color.blueMultiplier;
			}
			else
			{
				newColor.redMultiplier = 4 - color.redMultiplier;
				newColor.greenMultiplier = 4 - color.greenMultiplier;
				newColor.blueMultiplier = 4 - color.blueMultiplier;
			}
			
			polarity = !polarity;
			return newColor;
		}
	}
}