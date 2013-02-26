package  
{
	import Entities.Avatar;
	import Entities.Followers.*;
	import Entities.Forest.*;
	import Entities.Beach.*;
	import Entities.Parents.PlayerFollower;
	import flash.utils.*;
	
	public class EntitySpawner 
	{
		
		public function EntitySpawner() 
		{	
		}
		
		public static function SpawnEntities(terrain:int, entities:Array, map:Dictionary, width:int, height:int, baseX:int, baseY:int):void
		{
			if (terrain == Global.FOREST_FIELD_TERRAIN)
				SpawnEntitiesForest(entities, map, width, height, baseX, baseY);
		}
		
		public static function SpawnEntitiesForest(entities:Array, map:Dictionary, width:int, height:int, baseX:int, baseY:int):void
		{
			var rand:int = -1;
			var columns:Array = [];
			
			var spawnFollower:Boolean = true;
			var followers:Array = [];
			followers.push(new DeerDog(0, 0));
			followers.push(new RedMonkey(0, 0));
			followers.push(new HornBird(0, 0));
			
			var i:int;
			var l:int;
			for (i = 0; i < entities.length; i++){
				if (entities[i] is PlayerFollower && !entities[i].followingPlayer) spawnFollower = false;
				else{
					if (entities[i] is RedMonkey){
						for (l = followers.length-1; l >= 0; l--){
							if (followers[l] is RedMonkey){
								followers.splice(l, 1);
								break;
							}
						}
					}else if (entities[i] is DeerDog){
						for (l = followers.length-1; l >= 0; l--){
							if (followers[l] is DeerDog){
								followers.splice(l, 1);
								break;
							}
						}
					}else if (entities[i] is HornBird){
						for (l = followers.length-1; l >= 0; l--){
							if (followers[l] is HornBird){
								followers.splice(l, 1);
								break;
							}
						}
					}
				}
			}
			for (i = baseY/16; i <= (baseY+height)/16; i++){
				var skipABeat:Boolean;
				for (var j:int = baseX/16; j < (baseX+width)/16; j++){					
					var shouldIContinue:Boolean = false;
					for (var k:int = 0; k < columns.length; k++){
						if (columns[k] == j){
							shouldIContinue = true;
							break;
						}
					}if (shouldIContinue) continue;
					
					var ipu1String:String = "y"+(i).toString()+"x"+j.toString();
					if (map[ipu1String] != null && map[ipu1String].solid){						
						rand = Math.floor(Math.random()*4);
						if (rand <= 0){
							if (!spawnFollower || followers.length <= 0) break;
							spawnFollower = false;
							rand = Math.floor(Math.random()*followers.length);
							followers[rand].x = j*16;
							followers[rand].y = i*16-followers[rand].bb;
							entities.push(followers[rand]);
							followers.splice(rand, 1);
						}
						
						if (true){
							columns.push(j);
							columns.push(j+1);
							columns.push(j+2);
							var newTree:Tree = new Tree(j*16-16, i*16-80);
							if (Math.floor(Math.random()*3) <= 0)
								entities.push(new Cicada(newTree.x+Math.floor(Math.random()*8)+18, newTree.y+Math.floor(Math.random()*20)+30, newTree.currAniX));
							if (Math.floor(Math.random()*3) <= 0)
								entities.push(new Cicada(newTree.x+Math.floor(Math.random()*8)+18, newTree.y+Math.floor(Math.random()*10)+50, newTree.currAniX));
							if (Math.floor(Math.random()*3) <= 0)
								entities.push(new Songbird(newTree.x+8, newTree.y-9, 0));
							entities.push(newTree);
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
					entities[i].y > avatar.y+avatar.bb+160 ||
					entities[i].y+entities[i].bb < avatar.y-160){
						entities.splice(i, 1);
				}
			}
		}
	}
}