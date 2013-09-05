//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.events
{
    import mx.messaging.messages.IMessage;
    import mx.messaging.messages.AcknowledgeMessage;
    import flash.events.Event;

    public class MessageAckEvent extends MessageEvent 
    {

        public static const ACKNOWLEDGE:String = "acknowledge";

        public var correlation:IMessage;

        public function MessageAckEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:AcknowledgeMessage=null, _arg5:IMessage=null)
        {
            super(_arg1, _arg2, _arg3, _arg4);
            this.correlation = _arg5;
        }

        public static function createEvent(_arg1:AcknowledgeMessage=null, _arg2:IMessage=null):MessageAckEvent
        {
            return (new MessageAckEvent(MessageAckEvent.ACKNOWLEDGE, false, false, _arg1, _arg2));
        }


        public function get acknowledgeMessage():AcknowledgeMessage
        {
            return ((message as AcknowledgeMessage));
        }

        public function get correlationId():String
        {
            if (this.correlation != null)
            {
                return (this.correlation.messageId);
            };
            return (null);
        }

        override public function clone():Event
        {
            return (new MessageAckEvent(type, bubbles, cancelable, (message as AcknowledgeMessage), this.correlation));
        }

        override public function toString():String
        {
            return (formatToString("MessageAckEvent", "messageId", "correlationId", "type", "bubbles", "cancelable", "eventPhase"));
        }


    }
}//package mx.messaging.events
