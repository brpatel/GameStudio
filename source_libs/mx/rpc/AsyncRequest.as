//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    import mx.messaging.Producer;
    import mx.messaging.messages.AcknowledgeMessage;
    import mx.messaging.events.MessageEvent;
    import mx.messaging.messages.IMessage;
    import mx.messaging.events.MessageFaultEvent;
    import mx.messaging.messages.ErrorMessage;

    public class AsyncRequest extends Producer 
    {

        private var _pendingRequests:Object;

        public function AsyncRequest()
        {
            this._pendingRequests = {};
            super();
        }

        override public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void
        {
            var _local4:String;
            var _local5:IResponder;
            var _local3:Boolean = _arg1.headers[AcknowledgeMessage.ERROR_HINT_HEADER];
            super.acknowledge(_arg1, _arg2);
            if (!_local3)
            {
                _local4 = _arg1.correlationId;
                _local5 = IResponder(this._pendingRequests[_local4]);
                if (_local5)
                {
                    delete this._pendingRequests[_local4];
                    _local5.result(MessageEvent.createEvent(MessageEvent.RESULT, _arg1));
                };
            };
        }

        override public function fault(_arg1:ErrorMessage, _arg2:IMessage):void
        {
            super.fault(_arg1, _arg2);
            if (_ignoreFault)
            {
                return;
            };
            var _local3:String = _arg2.messageId;
            var _local4:IResponder = IResponder(this._pendingRequests[_local3]);
            if (_local4)
            {
                delete this._pendingRequests[_local3];
                _local4.fault(MessageFaultEvent.createEvent(_arg1));
            };
        }

        override public function hasPendingRequestForMessage(_arg1:IMessage):Boolean
        {
            var _local2:String = _arg1.messageId;
            return (this._pendingRequests[_local2]);
        }

        public function invoke(_arg1:IMessage, _arg2:IResponder):void
        {
            this._pendingRequests[_arg1.messageId] = _arg2;
            send(_arg1);
        }


    }
}//package mx.rpc
