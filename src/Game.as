package
{
	
	import flash.utils.Dictionary;
	
	import entity.BackgroundSky;
	import entity.Coin;
	import entity.Moveable;
	import entity.Rock;
	import entity.Runner;
	
	import hype.framework.core.ObjectPool;
	import hype.framework.core.TimeType;
	import hype.framework.rhythm.SimpleRhythm;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class Game extends Sprite 
	{
		public static const GAME_OVER:String = "gameOver";
		
		private var _background:BackgroundSky;
		private var _runner:Runner;
		
		private var _coinPool:ObjectPool;
		private var _rockPool:ObjectPool;
		private var _obstacles:Dictionary;
		private var _coins:Dictionary;
		
		private var _hitCount:int = 0;
		private var _cameraShake:Number;
		private var _chanceTexture:Texture;
		private var _chance:int;
		private var _chances:Vector.<Image>;
		private var _coin:int;
		private var _coinField:TextField;
		private var _coinIcon:Image;
		
		public function Game()
		{
			super();
			
			init();
			initUI();
		}

		private function initUI():void
		{
			_chanceTexture = Root.assets.getTextureAtlas('all').getTexture('chance_icon.png');
			_chances = new Vector.<Image>;
			chance = 2;
			
			_coinIcon = new Image(Root.assets.getTextureAtlas('all').getTexture('coin.png'));
			_coinIcon.scaleX = _coinIcon.scaleY = .8;
			_coinIcon.x = 380;
			_coinIcon.y = 10;
			addChild(_coinIcon);
			
			_coinField = new TextField(320, 48, "x 0", "CooperBlackStd", 24, 0xffffff);
			_coinField.hAlign = HAlign.LEFT;
			_coinField.x = 400
			_coinField.y = 10;
			addChild(_coinField);
			
			coin = 0;
		}
		
		private function init():void
		{
			_background = new BackgroundSky;
			Starling.juggler.add(_background);
			addChild(_background);
					
			_runner = new Runner;
			_runner.scaleX = _runner.scaleY = .5;
			_runner.x = 60;
			_runner.y = 180;
			addChild(_runner);
			
			Starling.juggler.add( _runner );
			
			_obstacles = new Dictionary;
			
			_rockPool = new ObjectPool( [Rock], 10 );
			_rockPool.onRequestObject = function(clip:Rock):void {
				// 초기화 
				clip.hasCollision = false;
				clip.x = 520;
				clip.y = 190;
				clip.scaleX = clip.scaleY = .8;
				addChild(clip);
				clip.spdX = -400;
				Starling.juggler.add(clip);
				
				_obstacles[clip] = clip;
				
				var onExit:ExitStageTrigger = new ExitStageTrigger(onExitStage, clip, stage);
				onExit.start();
			}
				
			var rhythm:SimpleRhythm = new SimpleRhythm(addNextClip);
			rhythm.start(TimeType.TIME, 1500);
			
			_coinPool = new ObjectPool( [Coin], 100 );
			_coinPool.onRequestObject = function(clip:Coin):void {
				// 초기화 
				clip.hasCollision = false;
				clip.x = 520;
				clip.y = 100;
				addChild(clip);
				Starling.juggler.add(clip);
				
				_obstacles[clip] = clip;
				
				var onExit:ExitStageTrigger = new ExitStageTrigger(onExitStage, clip, stage);
				onExit.start();
			}
			var coinRhythm:SimpleRhythm = new SimpleRhythm(addCoin);
			coinRhythm.start(TimeType.TIME, 100);
			
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function addCoin(r:SimpleRhythm):void
		{
			_coinPool.request();
		}
		
		private function onExitStage(clip:DisplayObjectContainer):void
		{
			destoryClip(clip);
		}
		
		public function destoryClip(clip:DisplayObjectContainer):void
		{
			removeChild(clip);
			
			_obstacles[clip] = null;
			delete _obstacles[clip]; 
			
			_rockPool.release(clip);
			_coinPool.release(clip);
		}
		
		private function addNextClip(r:SimpleRhythm):void
		{
			_rockPool.request();
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touchesBegin:Vector.<Touch> = event.getTouches(this,TouchPhase.BEGAN);
			var touchesEnd:Vector.<Touch> = event.getTouches(this,TouchPhase.ENDED);
			
			if(touchesBegin.length > 0) {
				_runner.jumping();
			}
			if(touchesEnd.length > 0) {
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			var count:int = 0;
			for(var clip:Moveable in _obstacles){
				
				//
				// enterFrame 에서 collision 을 체크 하므로 중복 체크가 된다.
				// Moveable 에 hasCollision 인자를 체크해 무시함.
				//
				if ( collisionWithDistance(_runner, clip) ){
					
					if(clip is Coin) {
						Coin(clip).collision();
						coin = coin+1;
					}
					if(clip is Rock) {
						_cameraShake = 20;
						Rock(clip).collision();
						
						if(chance > 0){
							chance = chance - 1;
						} else {
							dispatchEventWith(GAME_OVER, true);
						}
					}
				}
			}
			
			shakeAnimation();
		}
		
		private function collisionWithBound(host:Moveable, guest:Moveable):Boolean
		{
			if(guest.hasCollision) return false;
			if ( guest.bounds.intersects(host.bounds) ){
				guest.hasCollision = true;
				return true;
			} else {
				return false;
			}
		}
		
		private function collisionWithDistance(host:Moveable, guest:Moveable):Boolean
		{
			if(guest.hasCollision) return false;
			
			var dx:Number = (guest.x+guest.width/2) - (host.x+host.width/2);
			var dy:Number = (guest.y+guest.height/2) - (host.y+host.height/2);
			var distance:Number = Math.sqrt(dx*dx + dy*dy);
			
			var  radius1:Number = host.width / 2;
			var  radius2:Number = guest.width / 2;
			
			if (distance < radius1 + radius2) { 
				guest.hasCollision = true;
				return true;
			}
			else return false;
		}
		
		private function shakeAnimation():void
		{
			// Animate quake effect, shaking the camera a little to the sides and up and down.
			if (_cameraShake > 0)
			{
				_cameraShake -= 0.7;
				// Shake left right randomly.
				_background.x = int(Math.random() * _cameraShake - _cameraShake * 0.5); 
				// Shake up down randomly.
				_background.y = int(Math.random() * _cameraShake - _cameraShake * 0.5); 
			}
			else if (x != 0) 
			{
				// If the shake value is 0, reset the stage back to normal.
				// Reset to initial position.
				_background.x = 0;
				_background.y = 0;
			}
		}
		
		//=====================================================================
		//
		// getter and setter
		//
		//=====================================================================
		public function get chance():int
		{
			return _chance;
		}
		
		public function set chance(value:int):void
		{
			_chance = value;
			
			if(_chances.length > 0){
				for each (var temp:Image in _chances){
					removeChild(temp);
					temp = null;
				}
			}
			
			for(var i:int=0; i<value; i++){
				var chance:Image = new Image(_chanceTexture);
				chance.scaleX = chance.scaleY = .75;
				chance.x = i * 40 + 20;
				chance.y = 10;
				addChild(chance);
				_chances.push(chance);
			}
		}
		
		public function get coin():int
		{
			return _coin;
		}
		
		public function set coin(value:int):void
		{
			_coin = value;
			
			_coinField.text = 'x '+value;
		}
		
		
	}
}















