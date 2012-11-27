package Entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.si.sion.SiONVoice;
	
	public class VoiceOrb extends GameMover
	{
		public var voice:VoiceManager;
		public var color:ColorTransform;
		private var myAlpha:Number;
		public var orbFades:Array;
		private var startX:int;
		private var startY:int;
		public var maxLife:int;
		public var lifeSpan:int;
		
		[Embed(source = "../resources/images/glow_orb.png")]
		private var sprite_sheet:Class;
		
		public function VoiceOrb(x:int, y:int, voice:VoiceManager) 
		{
			super(x, y, 12, 12, 20, 20);
			startX = x;
			startY = y;
			maxLife = 600;
			lifeSpan = maxLife;
			
			//animation management creation
			myAlpha = 0.9;
			frameDelay = 8;
			maxFrame = 1;
			frameWidth = 32;
			frameHeight = 32;
			
			this.voice = new VoiceManager([]);
			this.voice.voice = voice.voice;
			this.voice.noteArray = voice.noteArray;
			this.voice.color = voice.color;
			
			this.color = new ColorTransform();
			this.color.redMultiplier = 4 - voice.color.redMultiplier;
			this.color.blueMultiplier = 4 - voice.color.blueMultiplier;
			this.color.greenMultiplier = 4 - voice.color.greenMultiplier;
			
			orbFades = [];
		}
		
		override public function Render(levelRenderer:BitmapData):void
		{	
			var temp_image:Bitmap = new Bitmap(new BitmapData(frameWidth, frameHeight));
			var temp_sheet:Bitmap = new sprite_sheet();
			
			if (visible)
				super.DrawSpriteFromSheet(temp_image, temp_sheet);
			else
			{
				for (var j:int = 0; j < image_sprite.numChildren;j++){
					image_sprite.removeChildAt(j);
				}
			}
		
			for (var i:int = 0; i < orbFades.length; i++)
			{
				orbFades[i].Render(levelRenderer);
			}
			
			//RENDER IT //CREATE ALPHA
			color.alphaMultiplier = myAlpha;
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			levelRenderer.draw(image_sprite, matrix, color);
		}
		
		public function Update():void
		{				
			x += vel.x;
			y += vel.y;
			lifeSpan--; 
			if (lifeSpan <= 0) 
				visible = false;
			else if (lifeSpan > maxLife-33)
			{
				startY++;
			}
			else visible = true;
			
			if (++frameCount >= frameDelay)
			{
				//move
				var dir:int = 1;
				if (startX < x) dir = -1;
				vel.x = (Math.random()*dir)*2;
				dir = 1;
				if (startY < y) dir = -1;
				vel.y = (Math.random()*dir)*2;
			
				//make
				currFrame = 0;
				if (visible)
					orbFades.push(new VoiceOrbFade(x, y, color));
				frameCount = 0;
			}
			
			//get rid 
			for (var i:int = orbFades.length-1; i >= 0; i--)
			{
				orbFades[i].Update();
				if (!orbFades[i].visible)
					orbFades.splice(i, 1);
			}
		}
	}
}