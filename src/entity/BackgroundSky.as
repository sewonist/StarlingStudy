package entity
{
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class BackgroundSky extends LoopClip
	{
		public function BackgroundSky()
		{
			super();
			
			xOffset = 8;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function init():void
		{
			var texture:Texture = Root.assets.getTexture("running_girl_bg");
			texture.repeat = true;
			
			setImage(new Image(texture));
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
}