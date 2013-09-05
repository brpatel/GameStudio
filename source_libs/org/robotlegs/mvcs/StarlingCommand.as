//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.mvcs
{
    import starling.display.DisplayObjectContainer;
    import org.robotlegs.core.ICommandMap;
    import flash.events.IEventDispatcher;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.IStarlingMediatorMap;
    import flash.events.Event;

    public class StarlingCommand 
    {

        [Inject]
        public var contextView:DisplayObjectContainer;
        [Inject]
        public var commandMap:ICommandMap;
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        [Inject]
        public var injector:IInjector;
        [Inject]
        public var mediatorMap:IStarlingMediatorMap;


        public function execute():void
        {
        }

        protected function dispatch(_arg1:Event):Boolean
        {
            if (this.eventDispatcher.hasEventListener(_arg1.type))
            {
                return (this.eventDispatcher.dispatchEvent(_arg1));
            };
            return (false);
        }


    }
}//package org.robotlegs.mvcs
