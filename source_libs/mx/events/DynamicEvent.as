//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public dynamic class DynamicEvent extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        public function DynamicEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false)
        {
            super(_arg1, _arg2, _arg3);
        }

        override public function clone():Event
        {
            var _local2:String;
            var _local1:DynamicEvent = new DynamicEvent(type, bubbles, cancelable);
            for (_local2 in this)
            {
                _local1[_local2] = this[_local2];
            };
            return (_local1);
        }


    }
}//package mx.events
