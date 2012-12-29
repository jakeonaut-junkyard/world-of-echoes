package Areas 
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.Parents.GameObject;
	import Entities.Door;
	import Managers.SoundManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.si.sion.SiONDriver;

	public class PentatonicMajor extends Area
	{
		public function PentatonicMajor()
		{
			super(Global.stageWidth*1.5, Global.stageHeight*1.4, Global.PENTATONIC_MAJOR_AREA);
			CreateScaleArray(12, Global.IONIAN_MODE);

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

			//etc
			groundColor = 0xFFFFFF;
		}
	}
}