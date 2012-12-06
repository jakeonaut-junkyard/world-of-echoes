package Areas 
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.GameObject;
	import Entities.Door;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.si.sion.SiONDriver;
	
	public class PentatonicMajor extends Area
	{
		//environment sounds
		[Embed(source = '../resources/sounds/cricketNight.mp3')]
		private var Cricket_ambient:Class;
		
		public function PentatonicMajor(avix:int, aviy:int, id:int)
		{
			super(avix, aviy, Global.stageWidth*1.5, Global.stageHeight*1.4, id);
			CreateScaleArray();
			
			//create entities
			solids = [
				new GameObject(0, 0-16, 0, 0, L_bitmap.width, 32), //ceiling
				new GameObject(0, Global.stageHeight-48, 0, 0, (L_bitmap.width)/2, 32), //floor1
				new GameObject(0, L_bitmap.height-32, 0, 0, (L_bitmap.width), 32), //floor 2
				new GameObject(0-16, 0, 0, 0, 32, Global.stageHeight-32), //Left wall
				new GameObject(L_bitmap.width-16, 0, 0, 0, 32, Global.stageHeight-16) //Right wall
			];
			doors = [
				new Door(292, 167, Global.DIATONIC_MINOR_AREA, 0-16, Global.stageHeight-16, 0, 0, 24, 48), //left door
				new Door(4, 167, Global.DIATONIC_MINOR_AREA, L_bitmap.width-8, Global.stageHeight-16, 0, 0, 24, 48) //right door
			];
			
			//environmental
			SoundManager.getInstance().addMusic(new Cricket_ambient(), "CricketAmbient");
			SoundManager.getInstance().playMusic("CricketAmbient", -5, int.MAX_VALUE);
			
			//etc
			groundColor = 0xFFFFFF;
		}
		
		override public function CreateScaleArray():void
		{
			//Create Pentatonic Cmajor scale
			scaleArray = [];
			for (var i:int = 24; i < 84; i++)
			{
				if (i%12==0 || 		//C
					(i-2)%12==0 ||	//D
					(i-4)%12==0 || 	//E
					(i-7)%12==0 ||	//G
					(i+3)%12==0)	//A
				scaleArray.push(i);
			}
		}
	}
}