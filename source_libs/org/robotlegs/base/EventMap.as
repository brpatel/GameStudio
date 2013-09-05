//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.base
{
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import org.robotlegs.core.*;

    public class EventMap implements IEventMap 
    {

        protected var eventDispatcher:IEventDispatcher;
        protected var _dispatcherListeningEnabled:Boolean = true;
        protected var listeners:Array;

        public function EventMap(_arg1:IEventDispatcher)
        {
            this.listeners = new Array();
            this.eventDispatcher = _arg1;
        }

        public function get dispatcherListeningEnabled():Boolean
        {
            return (this._dispatcherListeningEnabled);
        }

        public function set dispatcherListeningEnabled(_arg1:Boolean):void
        {
            this._dispatcherListeningEnabled = _arg1;
        }

        public function mapListener(_arg1:IEventDispatcher, _arg2:String, _arg3:Function, _arg4:Class=null, _arg5:Boolean=false, _arg6:int=0, _arg7:Boolean=true):void
        {
            var params:Object;
            var dispatcher:IEventDispatcher = _arg1;
            var type:String = _arg2;
            var listener:Function = _arg3;
            var eventClass = _arg4;
            var useCapture:Boolean = _arg5;
            var priority:int = _arg6;
            var useWeakReference:Boolean = _arg7;
            if ((((this.dispatcherListeningEnabled == false)) && ((dispatcher == this.eventDispatcher))))
            {
                throw (new ContextError(ContextError.E_EVENTMAP_NOSNOOPING));
            };
            eventClass = ((eventClass) || (Event));
            var i:int = this.listeners.length;
			if(i >0){
				while ((i = (i - 1)), i)
	            {
	                params = this.listeners[i];
	                if ((((((((((params.dispatcher == dispatcher)) && ((params.type == type)))) && ((params.listener == listener)))) && ((params.useCapture == useCapture)))) && ((params.eventClass == eventClass))))
	                {
	                    return;
	                };
	            };
			}
            var callback:Function = function (_arg1:Event):void
            {
                routeEventToListener(_arg1, listener, eventClass);
            };
            params = {
                dispatcher:dispatcher,
                type:type,
                listener:listener,
                eventClass:eventClass,
                callback:callback,
                useCapture:useCapture
            };
            this.listeners.push(params);
            dispatcher.addEventListener(type, callback, useCapture, priority, useWeakReference);
        }

        public function unmapListener(_arg1:IEventDispatcher, _arg2:String, _arg3:Function, _arg4:Class=null, _arg5:Boolean=false):void
        {
            var _local6:Object;
            _arg4 = ((_arg4) || (Event));
            var _local7:int = this.listeners.length;
            while (_local7--)
            {
                _local6 = this.listeners[_local7];
                if ((((((((((_local6.dispatcher == _arg1)) && ((_local6.type == _arg2)))) && ((_local6.listener == _arg3)))) && ((_local6.useCapture == _arg5)))) && ((_local6.eventClass == _arg4))))
                {
                    _arg1.removeEventListener(_arg2, _local6.callback, _arg5);
                    this.listeners.splice(_local7, 1);
                    return;
                };
            };
        }

        public function unmapListeners():void
        {
            var _local1:Object;
            var _local2:IEventDispatcher;
            while ((_local1 = this.listeners.pop()))
            {
                _local2 = _local1.dispatcher;
                _local2.removeEventListener(_local1.type, _local1.callback, _local1.useCapture);
            };
        }

        protected function routeEventToListener(_arg1:Event, _arg2:Function, _arg3:Class):void
        {
            if ((_arg1 is _arg3))
            {
                (_arg2(_arg1));
            };
        }


    }
}//package org.robotlegs.base
