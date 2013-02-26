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
		
		public static function GenerateMap(terrain:int, map:Dictionary, width:int, height:int, baseX:int, baseY:int, groundLevel:Boolean):void
		{
			if (terrain == Global.FOREST_FIELD_TERRAIN)
				GenerateForest(map, width, height, baseX, baseY, groundLevel);
		}
		
		public static function GenerateForest(map:Dictionary, width:int, height:int, baseX:int, baseY:int, groundLevel:Boolean):void
		{
			var rand:int = -1;
			var solid:Boolean = false;
			
			for (var i:int = (baseY+height)/16-1; i >= baseY/16; i--){
				for (var j:int = baseX/16; j < (baseX+width)/16; j++){
					solid = false;
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
					
					var ipu1String:String = "y"+(i+1).toString()+"x"+j.toString();
					var normString:String = "y"+i.toString()+"x"+j.toString();
					if ((i >= (baseY+height)/16-1 && groundLevel) || (solid
							&& map[ipu1String] != null && map[ipu1String].solid)){
						map[normString] = new Tile(j*16, i*16, 1, 0, true);
						map[ipu1String] = new Tile(j*16, (i+1)*16, 1, 1, true);
					}
					else if (map[ipu1String] != null && map[ipu1String].solid)
						map[normString] = new Tile(j*16, i*16, 0, 1);
					else
						map[normString] = new Tile(j*16, i*16, 0, 0);
				}
			}
		}
		
		public static function ShiftChunks(map:Dictionary, width:int, height:int, baseX:int, baseY:int, xShft:int, yShft:int):void
		{
			for (var i:int = (baseY+height)/16-1; i >= baseY/16; i--){
				for (var j:int = (baseX+width)/16-1; j >= baseX/16 ; j--){
					var normString:String = "y"+i.toString()+"x"+j.toString();
					var newString:String = "y"+(i+(yShft/16)).toString()+"x"+(j+(xShft/16)).toString();
					if (map[normString] != null){
						map[newString] = map[normString];
						map[newString].x += xShft;
						map[newString].y += yShft;
						delete map[normString];
					}
				}
			}
		}
		
		public static function DeleteChunk(map:Dictionary, width:int, height:int, baseX:int, baseY:int):Boolean
		{
			var returnVal:Boolean = false;
			for (var i:int = (baseY+height)/16-1; i >= baseY/16; i--){
				for (var j:int = baseX/16; j < (baseX+width)/16; j++){
					var normString:String = "y"+i.toString()+"x"+j.toString();
					if (map[normString] != null) returnVal = true;
					else break;
					delete map[normString];
				}
			}
			return returnVal;
		}
	}
}