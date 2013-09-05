//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    import flash.events.EventDispatcher;
    import mx.messaging.messages.IMessage;
    import mx.core.mx_internal;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.events.PropertyChangeEvent;

    use namespace mx_internal;

    public dynamic class AsyncToken extends EventDispatcher 
    {

        private var _message:IMessage;
        private var _responders:Array;
        private var _result:Object;

        public function AsyncToken(_arg1:IMessage=null)
        {
            this._message = _arg1;
        }

        public function get message():IMessage
        {
            return (this._message);
        }

        mx_internal function setMessage(_arg1:IMessage):void
        {
            this._message = _arg1;
        }

        public function get responders():Array
        {
            return (this._responders);
        }

        [Bindable(event="propertyChange")]
        public function get result():Object
        {
            return (this._result);
        }

        public function addResponder(_arg1:IResponder):void
        {
            if (this._responders == null)
            {
                this._responders = [];
            };
            this._responders.push(_arg1);
        }

        public function hasResponder():Boolean
        {
            return (((!((this._responders == null))) && ((this._responders.length > 0))));
        }

        mx_internal function applyFault(_arg1:FaultEvent):void
        {
            var _local2:uint;
            var _local3:IResponder;
            if (this._responders != null)
            {
                _local2 = 0;
                while (_local2 < this._responders.length)
                {
                    _local3 = this._responders[_local2];
                    if (_local3 != null)
                    {
                        _local3.fault(_arg1);
                    };
                    _local2++;
                };
            };
        }

        mx_internal function applyResult(_arg1:ResultEvent):void
        {
            var _local2:uint;
            var _local3:IResponder;
            this.setResult(_arg1.result);
            if (this._responders != null)
            {
                _local2 = 0;
                while (_local2 < this._responders.length)
                {
                    _local3 = this._responders[_local2];
                    if (_local3 != null)
                    {
                        _local3.result(_arg1);
                    };
                    _local2++;
                };
            };
        }

        mx_internal function setResult(_arg1:Object):void
        {
            var _local2:PropertyChangeEvent;
            if (this._result !== _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "result", this._result, _arg1);
                this._result = _arg1;
                dispatchEvent(_local2);
            };
        }


    }
}//package mx.rpc
