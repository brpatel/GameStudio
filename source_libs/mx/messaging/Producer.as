//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import mx.logging.Log;
    import mx.events.PropertyChangeEvent;
    import mx.messaging.messages.AsyncMessage;
    import mx.messaging.messages.IMessage;
    import mx.messaging.messages.AbstractMessage;

    public class Producer extends AbstractProducer 
    {

        public static const DEFAULT_PRIORITY:int = 4;

        private var _subtopic:String = "";

        public function Producer()
        {
            _log = Log.getLogger("mx.messaging.Producer");
            _agentType = "producer";
        }

        [Bindable(event="propertyChange")]
        public function get subtopic():String
        {
            return (this._subtopic);
        }

        public function set subtopic(_arg1:String):void
        {
            var _local2:PropertyChangeEvent;
            if (this._subtopic != _arg1)
            {
                if (_arg1 == null)
                {
                    _arg1 = "";
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "subtopic", this._subtopic, _arg1);
                this._subtopic = _arg1;
                dispatchEvent(_local2);
            };
        }

        override protected function internalSend(_arg1:IMessage, _arg2:Boolean=true):void
        {
            if (this.subtopic.length > 0)
            {
                _arg1.headers[AsyncMessage.SUBTOPIC_HEADER] = this.subtopic;
            };
            this.handlePriority(_arg1);
            super.internalSend(_arg1, _arg2);
        }

        private function handlePriority(_arg1:IMessage):void
        {
            var _local2:int;
            if (_arg1.headers[AbstractMessage.PRIORITY_HEADER] != null)
            {
                _local2 = _arg1.headers[AbstractMessage.PRIORITY_HEADER];
                if (_local2 < 0)
                {
                    _arg1.headers[AbstractMessage.PRIORITY_HEADER] = 0;
                }
                else
                {
                    if (_local2 > 9)
                    {
                        _arg1.headers[AbstractMessage.PRIORITY_HEADER] = 9;
                    };
                };
            }
            else
            {
                if (priority > -1)
                {
                    _arg1.headers[AbstractMessage.PRIORITY_HEADER] = priority;
                };
            };
        }


    }
}//package mx.messaging
