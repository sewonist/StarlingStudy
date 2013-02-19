package
{
	import hype.framework.trigger.AbstractTrigger;
	import hype.framework.trigger.ITrigger;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	
	public class ExitStageTrigger extends AbstractTrigger implements ITrigger
	{
		private var _stage:Stage;
		private var _target:DisplayObjectContainer; 
		
		public function ExitStageTrigger(callback:Function, target:Object, stage:Stage)
		{
			super(callback, target);
			
			_target = target as DisplayObjectContainer;
		}
		
		public function run(target:Object):Boolean
		{
			if(_target.x < -_target.width) return true;
			return false;
		}
	}
}