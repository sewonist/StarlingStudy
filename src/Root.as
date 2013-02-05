package
{
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
    
    

    /** The Root class is the topmost display object in your game. It loads all the assets
     *  and displays a progress bar while this is happening. Later, it is responsible for
     *  switching between game and menu. For this, it listens to "START_GAME" and "GAME_OVER"
     *  events fired by the Menu and Game classes. Keep this class rather lightweight: it 
     *  controls the high level behaviour of your game. */
    public class Root extends Sprite
    {
        private static var sAssets:AssetManager;
        
        private var mActiveScene:Sprite;
        
        public function Root()
        {
            // not more to do here -- Startup will call "start" immediately.
        }
        
        public function start(background:Texture, assets:AssetManager):void
        {
            // the asset manager is saved as a static variable; this allows us to easily access
            // all the assets from everywhere by simply calling "Root.assets"
            sAssets = assets;
            
            // The background is passed into this method for two reasons:
            // 
            // 1) we need it right away, otherwise we have an empty frame
            // 2) the Startup class can decide on the right image, depending on the device.
            
            addChild(new Image(background));
            
            // The AssetManager contains all the raw asset data, but has not created the textures
            // yet. This takes some time (the assets might be loaded from disk or even via the
            // network), during which we display a progress indicator. 
            
           
            assets.loadQueue(function onProgress(ratio:Number):void
            {
                trace(ratio);
                // a progress bar should always show the 100% for a while,
                // so we show the main menu only after a short delay. 
                
                if (ratio == 1){
					showCat();
					
					initText();
				}
                    
            });
        }
		
		private function showCat():void
		{
			var textures:Vector.<Texture> = assets.getTextureAtlas("cat_run").getTextures("cat_run");
			var cat_run:MovieClip = new MovieClip(textures);
			cat_run.x = (Constants.STAGE_WIDTH - cat_run.width) / 2;
			cat_run.y = 200;
			Starling.juggler.add( cat_run );
			
			addChild(cat_run);
		}
		
		private function initText():void
		{
			// 글씨가 텍스트폰트 안에 전부 안들어오면 보이지 않는다.
			var bitmapText:TextField = new TextField(200, 80, "비트맵 텍스트", 
				"NanumPen", 24, 0xffffff);
			bitmapText.x = (Constants.STAGE_WIDTH - bitmapText.width) / 2;
			bitmapText.y = 50;
			addChild(bitmapText);
			
			var embedText:TextField = new TextField(250, 50, "임베드 텍스트", 
				"YGO530", 24, 0);
			embedText.x = (Constants.STAGE_WIDTH - embedText.width) / 2;
			embedText.y = 100;
			addChild(embedText);
		}
		
        public static function get assets():AssetManager { return sAssets; }
		
    }
}