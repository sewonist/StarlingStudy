package entity
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Runner extends Moveable 
	{
		private var _runner:MovieClip;
		private var _runSfx:Sound;
		private var _runSfxChannel:SoundChannel;
		
		public function Runner()
		{
			_runSfx = Root.assets.getSound('run');
			
			var textures:Vector.<Texture> = Root.assets.getTextureAtlas("running_girl").getTextures("running_girl");
			_runner = new MovieClip(textures, 10);
			addChild(_runner);
			
			Starling.juggler.add(_runner);
			_runSfxChannel = _runSfx.play(0, 9999);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedStage);
		}
		
		private function onRemovedStage(event:Event):void
		{
			_runSfxChannel.stop();
			_runSfxChannel = null;
			_runSfx = null;
		}
		
		public function jumping():void
		{
			if (onSolid)
			{
				spdY = JUMP;
				onSolid = false;
				
				_runner.fps = 1;
			}
		}
		
		override public function advanceTime(time:Number):void
		{
			super.advanceTime(time);
			
			if(onSolid){
				_runner.fps = 10;
			}
		}
	}
}