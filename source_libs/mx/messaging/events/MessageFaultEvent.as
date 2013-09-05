//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.events
{
    import flash.events.Event;
    import mx.messaging.messages.ErrorMessage;

    public class MessageFaultEvent extends Event 
    {

        public static const FAULT:String = "fault";

        public var message:ErrorMessage;

        public function MessageFaultEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:ErrorMessage=null)
        {
            super(_arg1, _arg2, _arg3);
            this.message = _arg4;
        }

        public static function createEvent(_arg1:ErrorMessage):MessageFaultEvent
        {
            return (new MessageFaultEvent(MessageFaultEvent.FAULT, false, false, _arg1));
        }


        public function get faultCode():String
        {
            return (this.message.faultCode);
        }

        public function get faultDetail():String
        {
            return (this.message.faultDetail);
        }

        public function get faultString():String
        {
            return (this.message.faultString);
        }

        public function get rootCause():Object
        {
            return (this.message.rootCause);
        }

        override public function clone():Event
        {
            return (new MessageFaultEvent(type, bubbles, cancelable, this.message));
        }

        override public function toString():String
        {
            return (formatToString("MessageFaultEvent", "faultCode", "faultDetail", "faultString", "rootCause", "type", "bubbles", "cancelable", "eventPhase"));
        }


    }
}//package mx.messaging.events
