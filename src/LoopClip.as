package
{
	import flash.geom.Point;
	
	import starling.animation.IAnimatable;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class LoopClip extends Sprite implements IAnimatable
	{
		public var xOffset:Number = 0;
		public var yOffset:Number = 0;
		
		protected var _texture:Texture;
		protected var _image:Image;
		protected var _hRatio:Number = 1;
		protected var _vRatio:Number = 1;
		protected var _moveX:Number = 0;
		protected var _moveY:Number = 0;
		
		public function LoopClip()
		{
			super();
				
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		protected function init():void
		{
			// implement in subclass	
			// setImage();
		}
		
		protected function setImage(image:Image):void
		{
			_image = image;
			
			trace(_image.width, _image.height);
			
			// ratio used to fix the texture size later in the the setOffset method
			_hRatio = Constants.STAGE_WIDTH / _image.width;
			_vRatio = Constants.STAGE_HEIGHT / _image.height;
			
			// fill the whole stage with the background
			_image.width = Constants.STAGE_WIDTH;
			_image.height = Constants.STAGE_HEIGHT;
			
			// if the background does not need alpha channel only
			_image.blendMode = BlendMode.NONE;
			_image.smoothing = TextureSmoothing.NONE;
			
			addChild(_image);
		}
		
		protected function onEnterFrame(e:EnterFrameEvent):void
		{
//			if(_image){
//				_moveX += xOffset;
//				_moveY += yOffset;
//				setOffset(_moveX, _moveY);
//			}
		}
		
		protected function setOffset(xx:Number, yy:Number):void
		{
			yy = ((yy/_image.height % 1)+1) ;
			xx = ((xx/_image.width % 1)+1) ;
			
			_image.setTexCoords(0, new Point(xx, yy));
			_image.setTexCoords(1, new Point(xx + _hRatio, yy ));
			_image.setTexCoords(2, new Point(xx, yy + _vRatio));
			_image.setTexCoords(3, new Point(xx + _hRatio, yy + _vRatio));
		}
		
		public function advanceTime(passedTime:Number):void
		{
			if(_image){
				_moveX += xOffset;
				_moveY += yOffset;
				setOffset(_moveX, _moveY);
			}
		}
	}
}