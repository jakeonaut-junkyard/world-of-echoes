package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public var game:Game;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//Create the game object!!!
			game = new Game();
			
			//add the game bitmap to the screen/Main.as Sprite to make it visible
			addChild(game.screenBitmap);
			
			//create the main game loop
			addEventListener(Event.ENTER_FRAME, Run);
			
			//add keyboard listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, game.KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, game.KeyUp);
			
			//add mouse listeners
			stage.addEventListener(MouseEvent.MOUSE_DOWN, game.MouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, game.MouseUp);
		}
		
		public function Run(e:Event):void
		{
			game.Update();
			game.Render();
		}
	}
}