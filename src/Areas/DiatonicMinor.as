package Areas 
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.VoiceOrb;
	import Entities.GameObject;
	import Entities.Door;
	import Entities.SoundObjects.Arpeggio;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.si.sion.SiONDriver;
	
	public class DiatonicMinor extends Area
	{
		
		public function DiatonicMinor(avix:int, aviy:int, id:int)
		{
			super(avix, aviy, Global.stageWidth*1.5, Global.stageHeight*1.4, id);
			CreateScaleArray();
			
			//create entities
			solids = [
				new GameObject(0, 0-16, 0, 0, L_bitmap.width, 32), //ceiling
				new GameObject(L_bitmap.width/2, Global.stageHeight-48, 0, 0, L_bitmap.width/2+2, 32), //floor1
				new GameObject(0, L_bitmap.height-32, 0, 0, L_bitmap.width, 32), //floor 2
				new GameObject(0-16, 0, 0, 0, 32, L_bitmap.height), //Left wall
				new GameObject(L_bitmap.width-16, 0, 0, 0, 32, Global.stageHeight-32) //Right wall
			];
			doors = [new Door(4, 167, Global.PENTATONIC_MAJOR_AREA, L_bitmap.width-8, Global.stageHeight-16, 0, 0, 24, 48)];
			
			//etc
			groundColor = 0xFF9933;
		}
		
		override public function CreateScaleArray():void
		{
			//Create Diatonic Cminor scale
			scaleArray = [];
			for (var i:int = 24; i < 84; i++)
			{
				if (i%12==0 || 		//C
					(i-2)%12==0 ||	//D
					(i-3)%12==0 || 	//Eb
					(i-5)%12==0 ||	//F
					(i-7)%12==0 ||	//G
					(i+4)%12==0 ||	//Ab
					(i+2)%12==0)	//Bb
				scaleArray.push(i);
			}
		}
	}
}