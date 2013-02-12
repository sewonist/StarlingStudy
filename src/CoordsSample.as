package
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import flash.geom.Point;
	
	public class CoordsSample extends Sprite
	{
		private var _image:Image;
		public function CoordsSample()
		{
			super();
			
			var texture:Texture = Root.assets.getTexture("sample");
			texture.repeat = true;
			_image = new Image(texture);
			_image.x = Constants.STAGE_WIDTH - _image.width >> 1;
			addChild(_image);
			
			test3();
		}
		
		private function test1():void
		{
			_image.setTexCoords(0, new Point(0, 0));
			_image.setTexCoords(1, new Point(1, 0));
			_image.setTexCoords(2, new Point(0, 1));
			_image.setTexCoords(3, new Point(1, 1));
		}
		
		private function test2():void
		{
			_image.setTexCoords(0, new Point(-1, 0));
			_image.setTexCoords(1, new Point(1, 0));
			_image.setTexCoords(2, new Point(0, 1));
			_image.setTexCoords(3, new Point(1, 1));
		}
		
		private function test3():void
		{
			_image.setTexCoords(0, new Point(0, 0));
			_image.setTexCoords(1, new Point(2, 0));
			_image.setTexCoords(2, new Point(0, 1));
			_image.setTexCoords(3, new Point(1, 1));
		}
		
		private function test4():void
		{
			_image.setTexCoords(0, new Point(0, 0));
			_image.setTexCoords(1, new Point(1, 0));
			_image.setTexCoords(2, new Point(0, -1));
			_image.setTexCoords(3, new Point(1, 1));
		}
	}
}