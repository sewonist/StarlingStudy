package entity
{
	import flash.media.Sound;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Rock extends Moveable
	{	
		private var _rockSfx:Sound;
		private var _invaildCollision:Boolean = true;
		public function Rock()
		{
			var texture:Texture = Root.assets.getTextureAtlas('all').getTexture('Rock.png');
			var image:Image = new Image(texture);
			addChild(image);
			
			GRAV = 0;
			spdX = -500;
			
			_rockSfx = Root.assets.getSound('rock');
			
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function collision():void
		{
			if(_invaildCollision){
				_invaildCollision = false;
				_rockSfx.play();
			}
		}
		
		private function onRemovedFromStage(event:starling.events.Event):void
		{
			_invaildCollision = true;
		}
	}
}