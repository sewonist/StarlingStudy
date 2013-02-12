package
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Game extends Sprite
	{
		public static const GAME_OVER:String = "gameOver";
		
		private var _background:BackgroundSky;
		private var _running_men:MovieClip;
		
		public function Game()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_background = new BackgroundSky;
			Starling.juggler.add(_background);
			addChild(_background);
			
			var textures:Vector.<Texture> = Root.assets.getTextureAtlas("running_men").getTextures("running_men");
			_running_men = new MovieClip(textures, 12);
			_running_men.x = 80;
			_running_men.y = 260;
			Starling.juggler.add( _running_men );
			addChild(_running_men);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touchesBegin:Vector.<Touch> = event.getTouches(this,TouchPhase.BEGAN);
			var touchesEnd:Vector.<Touch> = event.getTouches(this,TouchPhase.ENDED);
			if(touchesBegin.length > 0) {
				_background.xOffset = 16;
				_running_men.fps = 24;
			}
			if(touchesEnd.length > 0) {
				_background.xOffset = 2;
				_running_men.fps = 12;
			}
		}
	}
}