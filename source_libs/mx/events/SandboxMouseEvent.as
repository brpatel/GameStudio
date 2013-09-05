//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class SandboxMouseEvent extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const CLICK_SOMEWHERE:String = "clickSomewhere";
        public static const DOUBLE_CLICK_SOMEWHERE:String = "doubleClickSomewhere";
        public static const MOUSE_DOWN_SOMEWHERE:String = "mouseDownSomewhere";
        public static const MOUSE_MOVE_SOMEWHERE:String = "mouseMoveSomewhere";
        public static const MOUSE_UP_SOMEWHERE:String = "mouseUpSomewhere";
        public static const MOUSE_WHEEL_SOMEWHERE:String = "mouseWheelSomewhere";

        public var altKey:Boolean;
        public var buttonDown:Boolean;
        public var ctrlKey:Boolean;
        public var shiftKey:Boolean;

        public function SandboxMouseEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Boolean=false, _arg5:Boolean=false, _arg6:Boolean=false, _arg7:Boolean=false)
        {
            super(_arg1, _arg2, _arg3);
            this.ctrlKey = _arg4;
            this.altKey = _arg5;
            this.shiftKey = _arg6;
            this.buttonDown = _arg7;
        }

        public static function marshal(_arg1:Event):SandboxMouseEvent
        {
            var _local2:Object = _arg1;
            return (new SandboxMouseEvent(_local2.type, _local2.bubbles, _local2.cancelable, _local2.ctrlKey, _local2.altKey, _local2.shiftKey, _local2.buttonDown));
        }


        override public function clone():Event
        {
            return (new SandboxMouseEvent(type, bubbles, cancelable, this.ctrlKey, this.altKey, this.shiftKey, this.buttonDown));
        }


    }
}//package mx.events
