package LoaderManagers 
{
	import Entities.Avatar;
	import Entities.Environment.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class EnvironmentManager 
	{
		public var rain:Boolean;
		public var rainDrops:Array;
		public var rainSound:Boolean;
		public var rainTimer:int;
		public var maxPrecipitation:int;
		
		public static var treeVoice:VoiceManager;
		public var beachTimer:int;
		public var fireflyTimer:int;
		
		public var x:Number;
		public var y:Number;
		public var width:int;
		public var height:int;
		
		public function EnvironmentManager() 
		{
			this.x = 125;
			this.y = 60;
			width = Global.stageWidth;
			height = Global.stageHeight;
			
			treeVoice = new VoiceManager();
			treeVoice.SetVoice(7, 10);
			fireflyTimer = 2;
			beachTimer = 0;
			
			rain = false;
			rainDrops = [];
			rainSound = false;
			rainTimer = 320;
			maxPrecipitation = 480;
		}
		
		public function Render(levelRenderer:BitmapData, l_bitmap:Bitmap):void
		{	
			x = -l_bitmap.x;
			y = -l_bitmap.y-8;
			for (var i:int = 0; i < rainDrops.length; i++){
				var height:int = Math.floor(rainDrops[i][2]/3);
				levelRenderer.fillRect(new Rectangle(rainDrops[i][0]+x, rainDrops[i][1]+y, 1, height), 0x0000FF);
			}
		}
		
		public function Update(entities:Array, avatarIndex:int):void
		{	
			treeVoice.TranslateNoteArray(Game._SiONArray);
			if (Global.CheckKeyPressed(Global.ENTER)){
				treeVoice.SetRandomVoice();
			}
			
			
			var avatar:Avatar = entities[avatarIndex];
			if (GameWorld.baseX >= 240 && GameWorld.baseX <= 1200){
				fireflyTimer--;
				if (fireflyTimer <= 0){
					var randX:int = Math.floor(Math.random()*(Global.stageWidth-64))+32;
					var randY:int = Math.floor(Math.random()*(Global.stageHeight-64))+32;
					entities.push(new Firefly(randX+x, randY+y));
					
					randX = Math.floor(Math.random()*(Global.stageWidth-64))+32;
					randY = Math.floor(Math.random()*(Global.stageHeight-64))+32;
					entities.push(new Firefly(randX+x, randY+y));
					fireflyTimer = Math.floor(Math.random()*20)+10;
				}
			}
			
			if (GameWorld.baseX < 480 || GameWorld.baseX >= 1440){
				beachTimer--;
				if (beachTimer <= 0){
					SoundManager.getInstance().playSfx("ShoreAmbience", -5, 1);
					beachTimer = 230;
				}
			}else{ beachTimer = 0; }
			
			//UpdateWeather();
		}
		
		public function UpdateWeather():void
		{
			var i:int;
			if (rainTimer > 0) rainTimer--;
			if (rainTimer <= 0){
				var rand:int = Math.floor(Math.random()*5);
				if (rand == 0 && !rain) rain = true;
				else if (rand == 0 && rain) rain = false;
				rainTimer = 1280;
			}
			
			if (rain){
				if (!rainSound){
					SoundManager.getInstance().playSfx("RainAmbience", -5, int.MAX_VALUE);
					rainSound = true;
				}
				
				if (rainDrops.length < maxPrecipitation){
					for (i = 0; i < 3; i++){
						if (rainDrops.length >= maxPrecipitation) break;
						var x:Number = Math.floor(Math.random()*width);
						var grav:Number = Math.random()*6+10;
						rainDrops.push([x, 0, grav]);
					}
				}
			}
			else{
				if (rainSound){
					SoundManager.getInstance().stopSfx("RainAmbience");
					rainSound = false;
				}
			}
			
			for (i = rainDrops.length-1; i >= 0; i--){
				rainDrops[i][1] += rainDrops[i][2];
				if (rainDrops[i][1] > height+4) rainDrops.splice(i, 1);
			}
		}
	}
}