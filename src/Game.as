package
{
	
	import flash.utils.Dictionary;
	
	import hype.framework.core.ObjectPool;
	import hype.framework.core.TimeType;
	import hype.framework.rhythm.SimpleRhythm;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Game extends Sprite 
	{
		public static const GAME_OVER:String = "gameOver";
		
		private var _background:BackgroundSky;
		private var _running_men:RunningMen;
		
		private var _coinPool:ObjectPool;
		private var _rockPool:ObjectPool;
		private var _obstacles:Dictionary;
		private var _coins:Dictionary;
		
		private var _hitCount:int = 0;
		private var _cameraShake:Number;
		
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
					
			_running_men = new RunningMen;
			_running_men.x = 60;
			_running_men.y = 130;
			addChild(_running_men);
			
			Starling.juggler.add( _running_men );
			
			_obstacles = new Dictionary;
			
			_rockPool = new ObjectPool( [Rock], 10 );
			_rockPool.onRequestObject = function(clip:Rock):void {
				// 초기화 
				clip.x = 520;
				clip.y = 220;
				addChild(clip);
				clip.spdX = -400 + (-200 * Math.random());
				Starling.juggler.add(clip);
				
				_obstacles[clip] = clip;
				
				var onExit:ExitStageTrigger = new ExitStageTrigger(onExitStage, clip, stage);
				onExit.start();
			}
				
			var rhythm:SimpleRhythm = new SimpleRhythm(addNextClip);
			rhythm.start(TimeType.TIME, 1000);
			
			_coinPool = new ObjectPool( [Coin], 100 );
			_coinPool.onRequestObject = function(clip:Coin):void {
				// 초기화 
				clip.x = 520;
				clip.y = 50;
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
		
		private function destoryClip(clip:DisplayObjectContainer):void
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
				_running_men.jumping();
			}
			if(touchesEnd.length > 0) {
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			var count:int = 0;
			for(var clip:Moveable in _obstacles){
				
				if ( collisionWithDistance(_running_men, clip) ){
					trace('hit', _hitCount++);
					destoryClip(clip);
					
					if(clip is Rock) _cameraShake = 20;
				}
				
			}
			
			shakeAnimation();
		}
		
		private function collisionWithBound(host:DisplayObject, guest:DisplayObject):Boolean
		{
			return guest.bounds.intersects(host.bounds);
		}
		
		private function collisionWithDistance(host:DisplayObject, guest:DisplayObject):Boolean
		{
			var dx:Number = (guest.x+guest.width/2) - (host.x+host.width/2);
			var dy:Number = (guest.y+guest.height/2) - (host.y+host.height/2);
			var distance:Number = Math.sqrt(dx*dx + dy*dy);
			
			var  radius1:Number = host.width / 2;
			var  radius2:Number = guest.width / 2;
			
			if (distance < radius1 + radius2) return true;
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
	}
}


import starling.animation.IAnimatable;
import starling.core.Starling;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.MovieClip;
import starling.textures.Texture;

internal class Moveable extends DisplayObjectContainer implements IAnimatable
{
	/**
	 * Entity -type- to consider solid when colliding.
	 */
	public var solid:String = "solid";
	
	/**
	 * Movement constants.
	 */
	public var MAXX:Number = 250;
	public var MAXY:Number = 1400;
	public var GRAV:Number = 2000;
	public var FLOAT:Number = 3000;
	public var ACCEL:Number = 1600;
	public var DRAG:Number = 800;
	public var JUMP:Number = -1200;
	public var LEAP:Number = 1.5;
	
	/**
	 * Movement properties.
	 */
	public var onSolid:Boolean;
	public var spdX:Number = 0;
	public var spdY:Number = 0;
	
	/**
	 * Helper vars used by move().
	 */
	private var _moveX:Number = 0;
	private var _moveY:Number = 0;
	
	public function Moveable()
	{
	}
	
	public function advanceTime(time:Number):void
	{
		checkFloor();
		gravity(time);
		move(spdX * time, spdY * time);
	}
	
	/**
	 * Moves the entity by the specified amount horizontally and vertically.
	 */
	public function move(moveX:Number = 0, moveY:Number = 0):void
	{
		// movement counters
		_moveX += moveX;
		_moveY += moveY;
		moveX = Math.round(_moveX);
		moveY = Math.round(_moveY);
		_moveX -= moveX;
		_moveY -= moveY;
		
		// movement vars
		var sign:int;
		
		// horizontal
		if (moveX != 0)
		{
			sign = moveX > 0 ? 1 : -1;
			while (moveX != 0)
			{
				moveX -= sign;
				x += sign;
			}
		}
		
		// vertical
		if (moveY != 0)
		{
			sign = moveY > 0 ? 1 : -1;
			while (moveY != 0)
			{
				moveY -= sign;
				if (collideFloor(x, y + sign))
				{
					moveY = 0;
					onSolid = true;
				}
				else y += sign;
			}
		}
	}
	
	
	
	public function collideFloor(x:Number, y:Number):Boolean
	{
		if( y > 150 ) return true;
		else return false;
	}
	
	/**
	 * Check floor
	 */
	protected function checkFloor():Boolean
	{
		if(y>150) onSolid = true;
		else onSolid = false;
		
		return onSolid;
	}
	
	/**
	 * Applies gravity to the player.
	 */
	protected function gravity(time:Number):void
	{
		if (onSolid) return;
		var g:Number = GRAV;
		if (spdY < 0) g += FLOAT;
		spdY += g * time;
		if (spdY > MAXY) spdY = MAXY;
	}
}

internal class Coin extends Moveable
{	
	public function Coin()
	{
		var texture:Texture = Root.assets.getTexture('coin');
		var image:Image = new Image(texture);
		addChild(image);
		
		GRAV = 0;
		spdX = -500;
	}
}

internal class Rock extends Moveable
{	
	public function Rock()
	{
		var texture:Texture = Root.assets.getTexture('Rock');
		var image:Image = new Image(texture);
		addChild(image);
		
		GRAV = 0;
		spdX = -500;
	}
}

internal class RunningMen extends Moveable 
{
	private var _runningMen:MovieClip;
	
	public function RunningMen()
	{
		var textures:Vector.<Texture> = Root.assets.getTextureAtlas("running_men").getTextures("running_men");
		_runningMen = new MovieClip(textures, 10);
		addChild(_runningMen);
		
		Starling.juggler.add(_runningMen);
	}
	
	public function jumping():void
	{
		if (onSolid)
		{
			spdY = JUMP;
			onSolid = false;
			
			_runningMen.fps = 1;
		}
	}
	
	override public function advanceTime(time:Number):void
	{
		super.advanceTime(time);
		
		if(onSolid){
			_runningMen.fps = 24;
		}
	}
}








