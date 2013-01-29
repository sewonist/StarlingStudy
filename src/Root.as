package
{
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
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
				}
                    
            });
        }
		
		private function showCat():void
		{
			var textures:Vector.<Texture> = assets.getTextureAtlas("cat_run").getTextures("cat_run");
			var cat_run:MovieClip = new MovieClip(textures);
			
			Starling.juggler.add( cat_run );
			
			addChild(cat_run);
		}
		
        public static function get assets():AssetManager { return sAssets; }
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
    }
}