package  
{
	import Entities.*;
	import Entities.Field.*;
	import Entities.Beach.*;
	import flash.utils.*;
	
	public class EntitySpawner 
	{
		
		public function EntitySpawner() 
		{	
		}
		
		public static function SpawnEntities(terrain:int, entities:Array, map:Dictionary, width:int, height:int, baseX:int):void
		{
			if (terrain == Global.FOREST_FIELD_TERRAIN)
				SpawnEntitiesForest(entities, map, width, height, baseX, 0);
		}
		
		public static function SpawnEntitiesForest(entities:Array, map:Dictionary, width:int, height:int, baseX:int, baseY:int):void
		{
			var rand:int = -1;
			var numEntities:int = 0;
			var columns:Array = [];
			
			var spawnDeerDog:Boolean = true;
			
			var i:int;
			for (i = 0; i < entities.length; i++){
				if (entities[i] is DeerDog) spawnDeerDog = false;
			}
			for (i = baseY/16; i < (baseY+height)/16; i++){
				var skipABeat:Boolean;
				for (var j:int = baseX/16; j < (baseX+width)/16; j++){					
					var shouldIBreak:Boolean = false;
					for (var k:int = 0; k < columns.length; k++){
						if (columns[k] == j){
							shouldIBreak = true;
							break;
						}
					}if (shouldIBreak) break;
					if (skipABeat){
						skipABeat = false;
						break;
					}
					
					var ipu1String:String = "y"+(i).toString()+"x"+j.toString();
					if (map[ipu1String] != null && map[ipu1String].solid){
						rand = Math.floor(Math.random()*(numEntities+2));
						columns.push(j);
						if (rand <= 0){
							skipABeat = true;
							numEntities++;
							rand = Math.floor(Math.random()*4);
							if (rand <= 0 && spawnDeerDog){
								entities.push(new DeerDog(j*16, i*16-16));
								spawnDeerDog = false;
							}else{
								entities.push(new Tree(j*16-16, i*16-80));
							}
						}
					}
				}
			}
		}
		
		public static function Despawn(avatar:Avatar, entities:Array):void
		{
			for (var i:int = entities.length-1; i >= 0; i--){
				if (entities[i].x > avatar.x+avatar.rb+240 ||
					entities[i].x+entities[i].rb < avatar.x-240 ||
					entities[i].y > avatar.y+avatar.bb+240 ||
					entities[i].y+entities[i].bb < avatar.y-240){
						entities.splice(i, 1);
				}
			}
		}
	}
}