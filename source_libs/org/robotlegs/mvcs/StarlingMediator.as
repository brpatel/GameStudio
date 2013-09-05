//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.mvcs
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import org.robotlegs.base.EventMap;
    import org.robotlegs.base.MediatorBase;
    import org.robotlegs.base.StarlingViewMap;
    import org.robotlegs.core.IEventMap;
    import org.robotlegs.core.IStarlingMediatorMap;
    
    import starling.display.DisplayObjectContainer;

    public class StarlingMediator extends MediatorBase 
    {

        [Inject]
        public var contextView:DisplayObjectContainer;
        [Inject]
        public var mediatorMap:IStarlingMediatorMap;
        protected var _eventDispatcher:IEventDispatcher;
        protected var _eventMap:IEventMap;


        override public function preRemove():void
        {
            if (this._eventMap)
            {
                this._eventMap.unmapListeners();
            };
            super.preRemove();
        }

        public function get eventDispatcher():IEventDispatcher
        {
            return (this._eventDispatcher);
        }

        [Inject]
        public function set eventDispatcher(_arg1:IEventDispatcher):void
        {
            this._eventDispatcher = _arg1;
        }

        protected function get eventMap():IEventMap
        {
			if(this._eventMap !=null)
				return this._eventMap;
			else
				this._eventMap = new EventMap(this.eventDispatcher);
			
			return this._eventMap;
    //        return (((this._eventMap) || ((this._eventMap = new EventMap(this.eventDispatcher)))));
        }

        protected function dispatch(_arg1:Event):Boolean
        {
            if (this.eventDispatcher.hasEventListener(_arg1.type))
            {
                return (this.eventDispatcher.dispatchEvent(_arg1));
            };
            return (false);
        }

        protected function addViewListener(_arg1:String, _arg2:Function, _arg3:Class=null, _arg4:Boolean=false, _arg5:int=0, _arg6:Boolean=true):void
        {
            this.eventMap.mapListener(IEventDispatcher(viewComponent), _arg1, _arg2, _arg3, _arg4, _arg5, _arg6);
        }

        protected function removeViewListener(_arg1:String, _arg2:Function, _arg3:Class=null, _arg4:Boolean=false):void
        {
            this.eventMap.unmapListener(IEventDispatcher(viewComponent), _arg1, _arg2, _arg3, _arg4);
        }

        protected function addContextListener(_arg1:String, _arg2:Function, _arg3:Class=null, _arg4:Boolean=false, _arg5:int=0, _arg6:Boolean=true):void
        {
            this.eventMap.mapListener(this.eventDispatcher, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6);
        }

        protected function removeContextListener(_arg1:String, _arg2:Function, _arg3:Class=null, _arg4:Boolean=false):void
        {
            this.eventMap.unmapListener(this.eventDispatcher, _arg1, _arg2, _arg3, _arg4);
        }


    }
}//package org.robotlegs.mvcs
