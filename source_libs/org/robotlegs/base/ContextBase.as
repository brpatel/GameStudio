//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.base
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.*;
    import org.robotlegs.core.*;

    public class ContextBase implements IContext, IEventDispatcher 
    {

        protected var _eventDispatcher:IEventDispatcher;

        public function ContextBase()
        {
            this._eventDispatcher = new EventDispatcher(this);
        }

        public function get eventDispatcher():IEventDispatcher
        {
            return (this._eventDispatcher);
        }

        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void
        {
            this.eventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4);
        }

        public function dispatchEvent(_arg1:Event):Boolean
        {
            if (this.eventDispatcher.hasEventListener(_arg1.type))
            {
                return (this.eventDispatcher.dispatchEvent(_arg1));
            };
            return (false);
        }

        public function hasEventListener(_arg1:String):Boolean
        {
            return (this.eventDispatcher.hasEventListener(_arg1));
        }

        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void
        {
            this.eventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }

        public function willTrigger(_arg1:String):Boolean
        {
            return (this.eventDispatcher.willTrigger(_arg1));
        }


    }
}//package org.robotlegs.base
