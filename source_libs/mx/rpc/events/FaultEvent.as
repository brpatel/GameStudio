//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc.events
{
    import mx.rpc.Fault;
    import mx.messaging.messages.AbstractMessage;
    import mx.rpc.AsyncToken;
    import mx.messaging.messages.IMessage;
    import mx.messaging.events.MessageFaultEvent;
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class FaultEvent extends AbstractEvent 
    {

        public static const FAULT:String = "fault";

        private var _fault:Fault;
        private var _headers:Object;
        private var _statusCode:int;

        public function FaultEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=true, _arg4:Fault=null, _arg5:AsyncToken=null, _arg6:IMessage=null)
        {
            super(_arg1, _arg2, _arg3, _arg5, _arg6);
            if (((!((_arg6 == null))) && (!((_arg6.headers == null)))))
            {
                this._statusCode = (_arg6.headers[AbstractMessage.STATUS_CODE_HEADER] as int);
            };
            this._fault = _arg4;
        }

        public static function createEventFromMessageFault(_arg1:MessageFaultEvent, _arg2:AsyncToken=null):FaultEvent
        {
            var _local3:Fault = new Fault(_arg1.faultCode, _arg1.faultString, _arg1.faultDetail);
            _local3.rootCause = _arg1.rootCause;
            return (new FaultEvent(FaultEvent.FAULT, false, true, _local3, _arg2, _arg1.message));
        }

        public static function createEvent(_arg1:Fault, _arg2:AsyncToken=null, _arg3:IMessage=null):FaultEvent
        {
            return (new FaultEvent(FaultEvent.FAULT, false, true, _arg1, _arg2, _arg3));
        }


        public function get fault():Fault
        {
            return (this._fault);
        }

        public function get headers():Object
        {
            return (this._headers);
        }

        public function set headers(_arg1:Object):void
        {
            this._headers = _arg1;
        }

        public function get statusCode():int
        {
            return (this._statusCode);
        }

        override public function clone():Event
        {
            return (new FaultEvent(type, bubbles, cancelable, this.fault, token, message));
        }

        override public function toString():String
        {
            return (formatToString("FaultEvent", "fault", "messageId", "type", "bubbles", "cancelable", "eventPhase"));
        }

        override mx_internal function callTokenResponders():void
        {
            if (token != null)
            {
                token.applyFault(this);
            };
        }


    }
}//package mx.rpc.events
