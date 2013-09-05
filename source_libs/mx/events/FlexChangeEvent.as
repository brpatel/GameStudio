//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class FlexChangeEvent extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const ADD_CHILD_BRIDGE:String = "addChildBridge";
        public static const REMOVE_CHILD_BRIDGE:String = "removeChildBridge";
        public static const STYLE_MANAGER_CHANGE:String = "styleManagerChange";

        public var data:Object;

        public function FlexChangeEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Object=null)
        {
            super(_arg1, _arg2, _arg3);
            this.data = _arg4;
        }

        override public function clone():Event
        {
            return (new FlexChangeEvent(type, bubbles, cancelable, this.data));
        }


    }
}//package mx.events
