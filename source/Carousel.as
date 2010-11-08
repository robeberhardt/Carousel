package
{
	import com.bit101.components.PushButton;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.theflashblog.fp10.SimpleZSorter;
	import com.thelab.utils.monster.Monster;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class Carousel extends Sprite
	{
		private var loader				: XMLLoader;
		private var settings			: XML;
		
		private var holder				: Sprite;
		private var actors				: Array;
		private var angleEach			: Number;
		
		public static const CAROUSEL_RADIUS		: Number = 550;
		
		private var debugger			: MonsterDebugger;
		
		public function Carousel()
		{
			debugger = new MonsterDebugger(this);
			Monster.enableAllLevels();
			Monster.clear();
						
			loader = new XMLLoader("settings.xml", { onComplete: settingsLoaded, onFail: settingsFail });
			loader.load();
		}
		
		private function settingsLoaded(e:LoaderEvent):void
		{
			settings = loader.content;
			Monster.info(this, "settings loaded");	
			Monster.info(this, settings);
			
			holder = new Sprite();
			holder.x = stage.stageWidth * .5;
			holder.y = stage.stageHeight * .5;
			holder.z = 400;
			holder.rotationX = 20;
			addChild(holder);
			
			var actorCount : Number = settings..actor.length();
			angleEach = (Math.PI * 2) / actorCount;
			
			actors = new Array();
			var count:uint=0;
			var xpos:Number = 150;
			makeNextActor();
			
			function makeNextActor():void	
			{
				var actor:Actor = new Actor(count, settings..actor[count]);
				actor.angle = (count * angleEach) + .5 - Math.PI/2;
//				actor.x = Math.cos(actor.angle) * CAROUSEL_RADIUS;
//				actor.z = Math.sin(actor.angle) * CAROUSEL_RADIUS;
				actor.rotationX = -20;
				//actor.rotationY = (360 / actorCount) * -count;
				actor.loadedSignal.addOnce(function(who:Actor):void 
				{
					count ++;
					if (count < actorCount) { makeNextActor(); } else { makeButtons(); }
				});
				holder.addChild(actor);
				actors.push(actor);
			}			
		}
		
		private function makeButtons():void
		{
			var leftButton:PushButton = new PushButton(this, 20, 20, "LEFT", onButtonPushed);
			var rightButton:PushButton = new PushButton(this, 20, 40, "RIGHT", onButtonPushed);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			//holder.rotationX = mouseY - 250;
			SimpleZSorter.sortClips(holder);
		}
		
		private function onButtonPushed(e:Event):void
		{
			var which:PushButton = e.target as PushButton;
			var newAngle:Number;
			if (which.label == "LEFT") { newAngle = angleEach; } else { newAngle = -angleEach; }
			for each (var a:Actor in actors)
			{
				TweenMax.to(a, 1, { angle: a.angle + newAngle, ease: Quad.easeInOut } );
			}
			
		}
			
		private function toDeg(rad:Number):Number
		{
			return rad/Math.PI*180;
		}
		
		private function toRad( deg:Number ):Number
		{
			return deg/180*Math.PI;
		}

		
		private function settingsFail(e:LoaderEvent):void
		{
			Monster.fatal(this, "settings couldn't load");
		}
	}
}