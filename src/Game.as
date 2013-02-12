package
{
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	public class Game extends Sprite
	{
		public static const GAME_OVER:String = "gameOver";
		
		public function Game()
		{
			super();
			init();
		}
		
		private function init():void
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			dispatchEventWith(GAME_OVER, true);
		}
	}
}