//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import mx.events.PropertyChangeEvent;
    import mx.messaging.messages.AsyncMessage;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.messages.IMessage;

    public class Consumer extends AbstractConsumer 
    {

        private var _selector:String = "";
        private var _subtopic:String = "";

        public function Consumer(_arg1:String="flex.messaging.messages.AsyncMessage")
        {
        }

        [Bindable(event="propertyChange")]
        public function get selector():String
        {
            return (this._selector);
        }

        public function set selector(_arg1:String):void
        {
            var _local2:PropertyChangeEvent;
            var _local3:Boolean;
            if (this._selector !== _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "selector", this._selector, _arg1);
                _local3 = false;
                if (subscribed)
                {
                    unsubscribe();
                    _local3 = true;
                };
                this._selector = _arg1;
                if (_local3)
                {
                    subscribe(clientId);
                };
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get subtopic():String
        {
            return (this._subtopic);
        }

        public function set subtopic(_arg1:String):void
        {
            var _local2:Boolean;
            if (this.subtopic != _arg1)
            {
                _local2 = false;
                if (subscribed)
                {
                    unsubscribe();
                    _local2 = true;
                };
                this._subtopic = _arg1;
                if (_local2)
                {
                    subscribe();
                };
            };
        }

        override protected function internalSend(_arg1:IMessage, _arg2:Boolean=true):void
        {
            if (this.subtopic.length > 0)
            {
                _arg1.headers[AsyncMessage.SUBTOPIC_HEADER] = this.subtopic;
            };
            if (this._selector.length > 0)
            {
                _arg1.headers[CommandMessage.SELECTOR_HEADER] = this._selector;
            };
            super.internalSend(_arg1, _arg2);
        }


    }
}//package mx.messaging
