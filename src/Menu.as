package
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import entity.BackgroundSky;
	
	public class Menu extends Sprite
	{
		public static const START_GAME:String = "startGame";
		
		private var _touch:TextField;
		private var _background:BackgroundSky;
		private var _title:Image;
		
		public function Menu()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			_background = new BackgroundSky;
			Starling.juggler.add(_background);
			addChild(_background);
			
			_touch = new TextField(320, 48, "touch here", "CooperBlackStd", 32, 0xffffff);
			_touch.x = Constants.STAGE_WIDTH - _touch.width >> 1;
			_touch.y = Constants.STAGE_HEIGHT * .68;
			addChild(_touch);
			
			_title = new Image(Root.assets.getTextureAtlas('all').getTexture('title.png'));
			_title.x = Constants.STAGE_WIDTH - _title.width >> 1;
			_title.y = Constants.STAGE_HEIGHT * .15;
			addChild(_title);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onAddedStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedStage);
			
			_background.xOffset = 1;
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