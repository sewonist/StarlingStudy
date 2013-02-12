package
{
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class Menu extends Sprite
	{
		public static const START_GAME:String = "startGame";
		
		private var _title:TextField;
		
		public function Menu()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			_title = new TextField(320, 48, "touch here", "CooperBlackStd", 32, 0xffffff);
			_title.y = Constants.STAGE_HEIGHT * 0.25;
			addChild(_title);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this,TouchPhase.ENDED);
			if(touches.length == 0) return;
			
			removeEventListener(TouchEvent.TOUCH, onTouch);
			dispatchEventWith(START_GAME, true);
		}
	}
}