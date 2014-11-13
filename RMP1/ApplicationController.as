package
{
	import feathers.controls.PanelScreen;
	import feathers.layout.VerticalLayout;
	import feathers.events.FeathersEventType;
	import feathers.controls.scrollContainer;
	import feathers.controls.scrollText;
	import feathers.themes.MetalWorksMobileTheme;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;


	public class ApplicationController extends PanelScreen
	{
		private const ENDPOINT_URL: String = "http://claire-fitzpatrick.github.io/";
		private var assetMgr: AssetManager;

		private var slideshowXML: XML;
		
		private var activeSlideImage:Image = null;
		
		private var currentSlideIndex:uint = 0;
		
		private var numSlides:uint;


		public function ApplicationController()
		{
			// constructor code
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandle);
		}
		private function initializeHandle(e:starling.events.Event):void
		{
			this.removeEventListener(FeathersEventType.INITIALIZE, initializeHandle);
			this.stage.addEventListener(starling.events.Event.RESIZE, stageResized);
			
			loadSlideShowXML();
		}

	}

}