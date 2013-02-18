package  
{
	import Entities.Tile;
	import flash.geom.Point;
	import flash.utils.*;
	
	public class MapGenerator 
	{		
		public function MapGenerator() 
		{
		}
		
		public static function GenerateField(map:Dictionary, width:int, height:int, baseX:int):void
		{
			var baseY:int = 0;
			var rand:int = -1;
			var solid:Boolean = false;
			
			for (var i:int = (baseY+height)/16-1; i >= baseY/16; i--){
				for (var j:int = baseX/16; j < (baseX+width)/16; j++){
					solid = false;
					if (i < height/16-1){
						var jmin1OnlyString:String = "y"+(i).toString()+"x"+(j-1).toString();
						var jmin1String:String = "y"+(i+1).toString()+"x"+(j-1).toString();
						var jpu1String:String = "y"+(i+1).toString()+"x"+(j+1).toString();
						
						if (!(map[jmin1String] != null && map[jmin1String].solid) ||
							!(map[jpu1String] != null && map[jpu1String].solid))
							solid = false;
						else if (map[jmin1OnlyString] != null && map[jmin1OnlyString].solid){
							rand = Math.floor(Math.random()*5);
							if (rand < 4) solid = true;
						}else{
							rand = Math.floor(Math.random()*2);
							if (rand == 0) solid = true;
						}
					}
					
					var ipu1String:String = "y"+(i+1).toString()+"x"+j.toString();
					var normString:String = "y"+i.toString()+"x"+j.toString();
					if (i >= (baseY+height)/16-1 || (solid
							&& map[ipu1String] != null && map[ipu1String].solid))
						map[normString] = new Tile(j*16, i*16, 1, 0, true);
					else
						map[normString] = new Tile(j*16, i*16, 0, 0);
				}
			}
		}
	}
}