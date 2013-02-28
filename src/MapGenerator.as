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
		
		public static function GenerateMap(baseX:int, baseY:int, map:Dictionary, width:int, height:int, calcX:int, calcY:int):void
		{
			for (var i:int = calcX; i < calcX+width; i+=GameWorld.C_WIDTH){
				for (var j:int = calcY+height-GameWorld.C_HEIGHT; j >= calcY; j-=GameWorld.C_HEIGHT){
					var terrain:int = -1;
					if (baseX+i == 1200) terrain = Global.MUSHROOM_FOREST_TERRAIN;
					else if (baseX+i >= 480 && baseX+i <= 1920) terrain = Global.FOREST_FIELD_TERRAIN;
					else terrain = Global.BEACH_TERRAIN;
					var myGroundLevel:int = baseY-height+j;
					switch(terrain){
						case Global.MUSHROOM_FOREST_TERRAIN:
							GenerateMushroomForest(map, width, height, i, j, (myGroundLevel == GameWorld.GROUND_LEVEL));
							break;
						case Global.FOREST_FIELD_TERRAIN:
							GenerateForest(map, width, height, i, j, (myGroundLevel == GameWorld.GROUND_LEVEL));
							break;
						case Global.BEACH_TERRAIN:
							GenerateBeach(map, width, height, i, j, (myGroundLevel == GameWorld.GROUND_LEVEL));
							break;
						default: break;
					}
				}
			}
		}
		
		public static function GenerateMushroomForest(map:Dictionary, width:int, height:int, calcX:int, calcY:int, groundLevel:Boolean):void
		{
			var rand:int = -1;
			var solid:Boolean = false;
			
			for (var i:int = (calcY+height)/16-1; i >= calcY/16; i--){
				for (var j:int = calcX/16; j < (calcX+width)/16; j++){
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
					if ((i >= (calcY+height)/16-1 && groundLevel) || (solid
							&& map[ipu1String] != null && map[ipu1String].solid)){
						if (Math.floor(Math.random()*2) <= 0)
							map[normString] = new Tile(j*16, i*16, 1, 2, true);
						else map[normString] = new Tile(j*16, i*16, 1, 0, true);
						if (i < (calcY+height)/16-1)
							map[ipu1String] = new Tile(j*16, (i+1)*16, 1, 1, true);
					}
					else if (map[ipu1String] != null && map[ipu1String].solid)
						map[normString] = new Tile(j*16, i*16, 0, 1);
					else
						map[normString] = new Tile(j*16, i*16, 0, 0);
				}
			}
		}
		
		public static function GenerateForest(map:Dictionary, width:int, height:int, calcX:int, calcY:int, groundLevel:Boolean):void
		{
			var rand:int = -1;
			var solid:Boolean = false;
			
			for (var i:int = (calcY+height)/16-1; i >= calcY/16; i--){
				for (var j:int = calcX/16; j < (calcX+width)/16; j++){
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
					if ((i >= (calcY+height)/16-1 && groundLevel) || (solid
							&& map[ipu1String] != null && map[ipu1String].solid)){
						map[normString] = new Tile(j*16, i*16, 1, 0, true);
						if (i < (calcY+height)/16-1)
							map[ipu1String] = new Tile(j*16, (i+1)*16, 1, 1, true);
					}
					else if (map[ipu1String] != null && map[ipu1String].solid)
						map[normString] = new Tile(j*16, i*16, 0, 1);
					else
						map[normString] = new Tile(j*16, i*16, 0, 0);
				}
			}
		}
		
		public static function GenerateBeach(map:Dictionary, width:int, height:int, calcX:int, calcY:int, groundLevel:Boolean):void
		{
			var rand:int = -1;
			
			for (var i:int = (calcY+height)/16-1; i >= calcY/16; i--){
				for (var j:int = calcX/16; j < (calcX+width)/16; j++){
					
					var ipu1String:String = "y"+(i+1).toString()+"x"+j.toString();
					var normString:String = "y"+i.toString()+"x"+j.toString();
					if ((i >= (calcY+height)/16-1 && groundLevel)){
						if (Math.floor(Math.random()*3) <= 0)
							map[normString] = new Tile(j*16, i*16, 3, 0, true);
						else
							map[normString] = new Tile(j*16, i*16, 3, 1, true);
					}
					else if (map[ipu1String] != null && map[ipu1String].solid 
							&& map[ipu1String].tileset_x == 3 && map[ipu1String].tileset_y == 0)
						map[normString] = new Tile(j*16, i*16, 2, 1);
					else
						map[normString] = new Tile(j*16, i*16, 0, 0);
				}
			}
		}
		
		public static function ShiftChunks(map:Dictionary, width:int, height:int, calcX:int, calcY:int, xShft:int, yShft:int):void
		{
			//trace("SHIFTwidth:"+width+",height:"+height+",calcX:"+calcX+",calcY:"+calcY);
			for (var i:int = (calcY+height)/16-1; i >= calcY/16; i--){
				for (var j:int = (calcX+width)/16-1; j >= calcX/16 ; j--){
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
		
		public static function DeleteChunk(map:Dictionary, width:int, height:int, calcX:int, calcY:int):Boolean
		{
			//trace("DELETEwidth:"+width+",height:"+height+",calcX:"+calcX+",calcY:"+calcY);
			var returnVal:Boolean = false;
			for (var i:int = (calcY+height)/16-1; i >= calcY/16; i--){
				for (var j:int = calcX/16; j < (calcX+width)/16; j++){
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