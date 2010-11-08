package 
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class GradientBox extends Sprite
	{
		private var _width									: Number;
		private var _height									: Number;
		private var _gradrot								: Number;
		private var _colorOne								: Number;
		private var _colorTwo								: Number;
		private var _alphaOne								: Number;
		private var _alphaTwo								: Number;
		private var _midpoint								: Number;
		
		public function GradientBox(w:Number=300, h:Number=300, r:Number=0, c1:Number=0xFF0000, c2:Number=0x000000, a1:Number=1, a2:Number=1, mp:Number=0.5) 
		{
			_width= w;
			_height= h;
			_gradrot = (180 + r) * Math.PI / 180;
			_colorOne = c1;
			_colorTwo = c2;
			_alphaOne = a1;
			_alphaTwo = a2;
			_midpoint = mp;
			
			//			trace("alpha1: " + _alphaOne + " - alpha2: " + _alphaTwo);
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			var colors:Array = [_colorOne, _colorTwo];
			var alphas:Array = [_alphaOne, _alphaTwo];
			var ratios:Array = [0, 255*_midpoint];
			var matr:Matrix = new Matrix();
			
			matr.createGradientBox(_width, _height, _gradrot, 0, 0);
			
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
			graphics.drawRect(0, 0, _width, _height);
			
		}
	}
}