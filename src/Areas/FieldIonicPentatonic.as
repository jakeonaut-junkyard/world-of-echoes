package Areas 
{
	import Entities.Avatar;
	import Entities.Burst;
	import Entities.Field.*;
	import Entities.Parents.GameObject;
	import Entities.Door;
	import Managers.SoundManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import org.si.sion.SiONDriver;

	public class FieldIonicPentatonic extends Area
	{
		[Embed(source = "../resources/images/field/00fieldForeground.png")]
		private var my_foreground:Class;
		[Embed(source = "../resources/images/field/00fieldMidground.png")]
		private var my_midground:Class;
		[Embed(source = "../resources/images/field/00fieldBackground.png")]
		private var my_background:Class;
		
		[Embed(source = "../resources/sounds/fieldAmbience.mp3")]
		private var Field_Ambience:Class;
		
		public function FieldIonicPentatonic()
		{
			super(840, 200, Global.FIELD_IONIC_PENTATONIC_AREA);
			CreateScaleArray(12, Global.IONIAN_MODE);
			_foreground = my_foreground;
			_midground = my_midground;
			_background = my_background;

			//create entities
			solids = [
				new GameObject(0, 0-16, 0, 0, L_bitmap.width, 32), //ceiling
				new GameObject(0, L_bitmap.height-40, 0, 0, (L_bitmap.width), 32), //floor
				new GameObject(0-16, 0, 0, 0, 32, 200) //Left wall
			];
			critters = [new SongBirds(), new Butterfly(201, 139), new Butterfly(217, 130)];
			doors = [];
			
			SoundManager.getInstance().addSfx(new Field_Ambience(), "FieldAmbience");
			SoundManager.getInstance().playSfx("FieldAmbience", -5, int.MAX_VALUE);

			//etc
			groundColor = 0xFFFFFF;
			L_bitmap.x-=64;
		}
		
		override public function EnterRoom(avatar:Avatar, avix:int, aviy:int, oldScale:Array = null):void
		{
			super.EnterRoom(avatar, avix, aviy, oldScale)
			avatar._voice.SetVoice(13, 45);
		}
	}
}