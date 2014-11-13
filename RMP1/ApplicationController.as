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
	import flash.system.ImageDecodingPolicy;
	import flash.events.TouchEvent;


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
		
		private function loadSlideShowXML()
		{
			var theURL:URLRequest = new URLRequest(this.ENDPOINT_URL + "slideshow.xml");
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, slideShowXMLLoaded);
			
			loader.load(theURL);
		}
		
		private function slideShowXMLLoaded(e:flash.events.Event):void
		{
			slideshowXML = new XML(e.target.data);
			
			assetMgr = new AssetManager();
			assetMgr.verbose = true;  
			
			var slideList:XMLList = slideshowXML.slide;
			this.numSlides = slideList.length();
			
			for (var i:int = 0; i < this.numSlides; i++)
			{
				assetMgr.enqueue(this.ENDPOINT_URL + slideshowXML.@imagePath + slideList[i].@image);
			}
			assetMgr.loadQueue(handleAssetsLoading);
		}
		
		private function handleAssetsLoading(ratioLoaded:Number):void
		{
			trace("handleAssetsLoading: " + ratioLoaded);
			
			if (ratioLoaded == 1)
			{
				startApp();
			}
		}
		private function startApp()
		{
			this.height = this.stage.stageHeight;
			this.width = this.stage.stageWidth;
			
			new MetalWorksMobileTheme();
			
			this.headerProperties.title = "Feathers and XML";
			
			var theLayout:VerticalLayout = new VerticalLayout();
			theLayout.gap = 10;
			theLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			this.layout = theLayout;
			this.displaySlide();
		}
		
		private function displaySlide(slideIndex:uint = 0):void
		{
			if (this.activeSlideImage != null)
			{
				activeSlideImage.removeEventListener(starling.events.TouchEvent.TOUCH, handleNextSlide);
				this.removeChild(activeSlideImage);
			}
			var slideName:String = this.slideshowXML.slide[slideIndex].@image;
			
			var indexOfLastDot:int = slideName.lastIndexOf(".");
			
			slideName = slideName.substr(0,indexOfLastDot);
			
			activeSlideImage = new Image(this.assetMgr.getTexture(slideName));
			activeSlideImage.width = this.stage.stageWidth;
			activeSlideImage.scaleY = activeSlideImage.scaleX;
			
			activeSlideImage.addEventListener(starling.events.TouchEvent.TOUCH, handleNextSlide);
			this.addChild(activeSlideImage);
		}
		
		private function handleNextSlide(e:starling.events.TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if (touch)
			{
				this.currentSlideIndex++;
				
				this.currentSlideIndex = this.currentSlideIndex % this.numSlides;
				this.displaySlide(this.currentSlideIndex);
			}
		}
		
		protected function stageResized(e:starling.events.Event):void
		{
			this.height = this.stage.stageHeight;
			this.width = this.stage.stageWidth;
		}

	}

}