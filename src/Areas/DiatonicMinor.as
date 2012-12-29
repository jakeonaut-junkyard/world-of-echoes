package Areas 
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.Parents.GameObject;
	import Entities.Door;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.si.sion.SiONDriver;

	public class DiatonicMinor extends Area
	{

		public function DiatonicMinor()
		{
			super(Global.stageWidth*1.5, Global.stageHeight*1.4, Global.DIATONIC_MINOR_AREA);
			CreateScaleArray(14, Global.DORIAN_MODE);

			//create entities
			solids = [
				new GameObject(0, 0-16, 0, 0, L_bitmap.width, 32), //ceiling
				new GameObject(L_bitmap.width/2, Global.stageHeight-48, 0, 0, L_bitmap.width/2+2, 32), //floor1
				new GameObject(0, L_bitmap.height-32, 0, 0, L_bitmap.width, 32), //floor 2
				new GameObject(0-16, 0, 0, 0, 32, Global.stageHeight-16), //Left wall
				new GameObject(L_bitmap.width-16, 0, 0, 0, 32, Global.stageHeight-32) //Right wall
			];
			doors = [
				new Door(4, 167, Global.PENTATONIC_MAJOR_AREA, L_bitmap.width-8, Global.stageHeight-16, 0, 0, 24, 48), //right door
				new Door(292, 167, Global.PENTATONIC_MAJOR_AREA, 0-16, Global.stageHeight-16, 0, 0, 24, 48) //left door
			];

			//etc
			groundColor = 0xFF9933;
		}
	}
}