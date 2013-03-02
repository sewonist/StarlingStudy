package entity
{
	import flash.media.Sound;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;
	
	public class Coin extends Moveable
	{	
		[Embed(source="/../embeds/star.pex", mimeType="application/octet-stream")]
		private const ParticleRef:Class;
		
		[Embed(source="/../embeds/star.png")]
		private const TextureRef:Class;
		
		private var _coinImage:Image;
		private var _particle:ParticleDesignerPS;
		private var _coinSfx:Sound;
		private var _invaildCollision:Boolean = true;
		
		public function Coin()
		{
			var texture:Texture = Root.assets.getTextureAtlas('all').getTexture('coin.png');
			_coinImage = new Image(texture);
			addChild(_coinImage);
			
			GRAV = 0;
			spdX = -500;
			
			initParticle();
			_coinSfx = Root.assets.getSound('coin');
			
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(event:starling.events.Event):void
		{
			_particle.stop();
			_coinImage.visible = true;
			_invaildCollision = true;
		}
		
		public function collision():void
		{
			if(_invaildCollision){
				_invaildCollision = false;
				_coinImage.visible = false;
				_particle.emitterX = x;
				_particle.emitterY = y-80;
				_particle.start(.5);
				_coinSfx.play();
			}
		}
		
		override public function advanceTime(time:Number):void
		{
			super.advanceTime(time);
			
			_particle.emitterX = x;
			_particle.emitterY = y-80;
		}
		
		private function initParticle():void
		{
			var config:XML = XML(new ParticleRef);
			var texture:Texture = Texture.fromBitmap(new TextureRef);
			_particle = new ParticleDesignerPS(config, texture);
			addChildAt(_particle, 1);
			
			Starling.juggler.add(_particle);
		}
	}
}