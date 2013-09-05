//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.events
{
    import flash.events.Event;
    import mx.messaging.messages.IMessage;

    public class MessageEvent extends Event 
    {

        public static const MESSAGE:String = "message";
        public static const RESULT:String = "result";

        public var message:IMessage;

        public function MessageEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:IMessage=null)
        {
            super(_arg1, _arg2, _arg3);
            this.message = _arg4;
        }

        public static function createEvent(_arg1:String, _arg2:IMessage):MessageEvent
        {
            return (new MessageEvent(_arg1, false, false, _arg2));
        }


        public function get messageId():String
        {
            if (this.message != null)
            {
                return (this.message.messageId);
            };
            return (null);
        }

        override public function clone():Event
        {
            return (new MessageEvent(type, bubbles, cancelable, this.message));
        }

        override public function toString():String
        {
            return (formatToString("MessageEvent", "messageId", "type", "bubbles", "cancelable", "eventPhase"));
        }


    }
}//package mx.messaging.events
