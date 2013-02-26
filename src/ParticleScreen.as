package
{
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class ParticleScreen extends Sprite
	{
		[Embed(source="/../embeds/magic.pex", mimeType="application/octet-stream")]
		private const ParticleRef:Class;
		
		[Embed(source="/../embeds/magic.png")]
		private const TextureRef:Class;
		private var _particle:PDParticleSystem;
		
		
		public function ParticleScreen()
		{
			super();
			
			var background:Quad = new Quad(480, 320, 0);
			//addChild(background);
			
			initParticle();
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function initParticle():void
		{
			var config:XML = XML(new ParticleRef);
			var texture:Texture = Texture.fromBitmap(new TextureRef);
			_particle = new PDParticleSystem(config, texture);
			addChild(_particle);
			
			Starling.juggler.add(_particle);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touchesBegin:Vector.<Touch> = event.getTouches(this,TouchPhase.BEGAN);
			var touchesEnd:Vector.<Touch> = event.getTouches(this,TouchPhase.ENDED);
			var touchesMoved:Vector.<Touch> = event.getTouches(this,TouchPhase.MOVED);
			
			if(touchesBegin.length > 0) {
				_particle.emitterX = touchesBegin[0].globalX;
				_particle.emitterY = touchesBegin[0].globalY;
				
				_particle.start();
			}
			if(touchesEnd.length > 0) {
				_particle.start(.5);
				//_particle.stop();
			}
			if(touchesMoved.length>0){
				_particle.emitterX = touchesMoved[0].globalX;
				_particle.emitterY = touchesMoved[0].globalY;
			}
		}
	}
}