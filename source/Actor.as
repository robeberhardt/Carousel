package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.thelab.utils.monster.Monster;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class Actor extends Sprite
	{
		private var index							: uint;
		private var assetPath						: String;
		private var vOffset							: Number;
		
		private var loader 							: ImageLoader;
		public var loadedSignal						: Signal;
		
		private var _angle							: Number;
		
		private var holder							: CarouselActor;
		private var image							: Bitmap;
		private var reflection						: Bitmap;
		private var reflectionHolder				: Sprite;
		
		private var hotspot							: Sprite;
		
		public function Actor(index: uint, data:XML)
		{
			this.index = index;
			this.assetPath = data..@path.toString();
			this.vOffset = Number(data..@vOffset);
			
			loader = new ImageLoader(assetPath, { onComplete: loadComplete, onFail: loadFail });
			loadedSignal = new Signal(Actor);
			scaleX = scaleY = .7;
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loader.load();
			
//			graphics.beginFill(0x00FF00, 1);
//			graphics.drawCircle(0, 0, 6);
//			graphics.endFill();
			
			
			
		}
		
		private function loadComplete(e:LoaderEvent):void
		{
			image = loader.rawContent;
			addChild(image);
			image.x = -Math.round(image.width*.5);
			image.y = -image.height + vOffset;
			
			reflectionHolder = new Sprite();
			addChild(reflectionHolder);
			reflection = new Bitmap();
			reflection.cacheAsBitmap = true;
			reflection.bitmapData = image.bitmapData;
			reflection.smoothing = true;
			reflectionHolder.addChild(reflection);
			reflectionHolder.x = -Math.round(image.width*.5);
			reflectionHolder.y = image.height  + -vOffset;
			reflection.scaleY = -1;
			
			var colorOne:Number = 0x00ff00;
			var colorTwo:Number = 0x0000ff;
			var alphaOne:Number = .5;
			var alphaTwo:Number = 0;
			var mp:Number = .75;
			var r:Number = -90;
			var gradmask:GradientBox = new GradientBox(image.width, image.height  + -vOffset, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
			gradmask.y = -image.height;
			gradmask.cacheAsBitmap = true;
			
			reflectionHolder.addChild(gradmask);
			reflection.mask = gradmask;
			
			hotspot = new Sprite();
			hotspot.graphics.beginFill(0xFF0000, 0);
			hotspot.graphics.drawRect(0, 0, image.width, image.height);
			hotspot.x = image.x;
			hotspot.y = image.y;
			addChild(hotspot);
			hotspot.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			hotspot.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			loadedSignal.dispatch(this);
		}
		
		private function rollOver(e:MouseEvent):void
		{
			TweenMax.to(image, .5, { y: -image.height + vOffset - 30, repeat:-1, yoyo:true, ease:Quad.easeInOut } );
			TweenMax.to(reflection, .5, { y: 30, repeat: -1, yoyo: true, ease:Quad.easeInOut });
		}
		
		private function rollOut(e:MouseEvent):void
		{
			TweenMax.killAll();
			TweenMax.to(image, .25, { y: -image.height + vOffset, ease:Quad.easeOut });
			TweenMax.to(reflection, .3, { y: 0, ease: Quad.easeOut });
		}
		
		private function loadFail(e:LoaderEvent):void
		{
			Monster.info(this, "failed to load asset");
		}

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
			x = Math.cos(_angle) * Carousel.CAROUSEL_RADIUS;
			z = Math.sin(_angle) * Carousel.CAROUSEL_RADIUS;
		}

	}
}