package com.thelab.utils.monster
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	/**
	 * Monster (based on 'Out' from BigSpaceship
	 *
	 * @author			rob eberhardt
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 * 
	 */
	public class Monster extends Sprite
	{
		public static const INFO		: Number = 0;
		public static const STATUS		: Number = 1;
		public static const DEBUG		: Number = 2;
		public static const WARNING		: Number = 3;
		public static const ERROR		: Number = 4;
		public static const FATAL		: Number = 5;
		
		public static const INFO_COLOR			:uint = 0x000000;
		public static const STATUS_COLOR		:uint = 0x8D4D9F;
		public static const DEBUG_COLOR			:uint = 0x5E9F4D;
		public static const WARNING_COLOR		:uint = 0xFF7000;
		public static const ERROR_COLOR			:uint = 0xFF0000;
		public static const FATAL_COLOR			:uint = 0xFF0000;
		
		private static var __levels		: Array = [];
		private static var __colors		: Array = [INFO_COLOR, STATUS_COLOR, DEBUG_COLOR, WARNING_COLOR, ERROR_COLOR, FATAL_COLOR];
		private static var __silenced	: Object = {};
		private static var __instance	: Monster;
				
		public function Monster() 
		{ 
		}
				
		/**
		 * Enable a specific debugging level 
		 * @param $level The level to enable
		 */		
		public static function enableLevel($level:Number):void 
		{
			__levels[$level] = __output;
		}
		
		/**
		 * Disable a specific debugging level 
		 * @param $level The level to disable
		 */		
		public static function disableLevel($level:Number):void 
		{
			__levels[$level] = null;
		}
		
		/**
		 * Enable all debugging levels 
		 */		
		public static function enableAllLevels():void
		{
			enableLevel(INFO   );
			enableLevel(STATUS );
			enableLevel(DEBUG  );
			enableLevel(WARNING);
			enableLevel(ERROR  );
			enableLevel(FATAL  );
		}
		
		/**
		 * Disable all debugging levels 
		 */		
		public static function disableAllLevels():void 
		{
			disableLevel(INFO   );
			disableLevel(STATUS );
			disableLevel(DEBUG  );
			disableLevel(WARNING);
			disableLevel(ERROR  );
			disableLevel(FATAL  );
		}
	
		/**
		 * Check to see if an object is currently being silenced 
		 * @param $o The object being checked
		 * @return A boolean indicating it's silenced state 
		 * @see silence
		 * @see unsilence
		 */
		public static function isSilenced($o:*):Boolean 
		{
			var s:String = __getClassName($o);
			
			return __silenced[s];
		}
		
		/**
		 * Silence a specific object from making debug calls. 
		 * @param $o
		 * @see unsilence
		 */
		public static function silence($o:*):void 
		{
			var s:String = __getClassName($o);
			
			__silenced[s] = true;
		}
		
		/**
		 * Enable an object to start making debug calls again after it has been silenced using <code>silence</code>.
		 * @param $o
		 * @see silence
		 */
		public static function unsilence($o:*):void 
		{
			var s:String = __getClassName($o);
			
			__silenced[s] = false;
		}
		
		public static function info($origin:*, ...$args):void 
		{
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(INFO) && __levels[INFO]!=null)
				__levels[INFO].apply(null, [Monster.INFO, "INFO", $origin, MonsterEvent.INFO].concat($args) );
		}
		
		public static function status($origin:*, ...$args):void 
		{
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(STATUS) && __levels[STATUS]!=null)
				__levels[STATUS].apply(null, [Monster.STATUS, "STATUS", $origin, MonsterEvent.STATUS].concat($args) );
		}
		
		public static function debug($origin:*, ...$args):void 
		{
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(DEBUG) && __levels[DEBUG]!=null)
				__levels[DEBUG].apply(null, [Monster.DEBUG, "DEBUG", $origin, MonsterEvent.DEBUG].concat($args) );
		}
		
		public static function warning($origin:*, ...$args):void 
		{
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(WARNING) && __levels[WARNING]!=null)
				__levels[WARNING].apply(null, [Monster.WARNING, "WARNING", $origin, MonsterEvent.WARNING].concat($args) );
		}
		
		public static function error($origin:*, ...$args):void 
		{
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(ERROR) && __levels[ERROR]!=null)
				__levels[ERROR].apply(null, [Monster.ERROR, "ERROR", $origin, MonsterEvent.ERROR].concat($args) );
		}
		
		public static function fatal($origin:*, ...$args):void 
		{
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(FATAL) && __levels[FATAL]!=null)
				__levels[FATAL].apply(null, [Monster.FATAL, "FATAL", $origin, MonsterEvent.FATAL].concat($args) );
		}
		
		/**
		 * Sends a clear message to any registered debuggers.  Doesn't do anything within the IDE.
		 */
		public static function clear():void
		{
			MonsterDebugger.clearTraces();
		}
		
//		public static function traceObject($origin:*, $str:String, $obj:*):void 
//		{
//			if(isSilenced($origin)) return;
//			
//			__output("OBJECT", $origin, $str, MonsterEvent.ALL);
//			for(var p:* in $obj) __output("", null, p + " : " + $obj[p], MonsterEvent.ALL);
//		}
		
		public static function addEventListener($type:String, $func:Function):void 
		{
			__getInstance().addEventListener($type, $func);
		}
		
		public static function removeEventListener($type:String, $func:Function):void 
		{
			__getInstance().removeEventListener($type, $func);
		}
		
		private static function __getInstance():Monster{
			return (__instance ? __instance : (__instance = new Monster()));
		}
		
		public static function createInstance():void {
			
			
			
			var i:*;
			var ii:*;
			var reSilence:Object = {};			
			var reDisable:Array = [];
			
			for(i in __silenced) { reSilence[i] = __silenced; }
			for(i in __levels) { if(__levels[i] && __levels[i] != null) reDisable.push(i); }			
			enableAllLevels();
			for(ii in reSilence) { silence(ii); }
			for(ii=0;ii<reDisable.length;ii++) { disableLevel(reDisable[ii]); }
		}
		
		private static function __output($level:Number, $levelName:String, $origin:*, $type:String, ...$objects):void
		{
			//trace("output ::: $level: " + $level + ", $name: " + $levelName + ", $origin: " + $origin);
			var ln:String = $levelName;
			var s:String = $origin ? __getClassName($origin) : "";
			var i:Monster    = __getInstance();
			
			while(ln.length < 8) ln += " ";
			
			MonsterDebugger.trace($origin, $objects[0], __colors[$level]);
			trace($levelName + " ::: " + $objects[0]);
			
//			i.dispatchEvent(new MonsterEvent(MonsterEvent.ALL, 	output));
//			i.dispatchEvent(new MonsterEvent($type,           	output));
		}
		
		private static function __getClassName($o:*):String 
		{
			var c:String = flash.utils.getQualifiedClassName($o);
			var s:String = (c == "String" ? $o : c.split("::")[1] || c);
			
			return s;
		}
	}
}