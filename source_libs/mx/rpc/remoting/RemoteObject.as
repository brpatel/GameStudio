//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc.remoting
{
    import mx.rpc.AbstractService;
    import mx.rpc.mxml.Concurrency;
    import mx.core.mx_internal;
    import mx.messaging.Channel;
    import mx.messaging.channels.SecureAMFChannel;
    import mx.messaging.channels.AMFChannel;
    import mx.messaging.ChannelSet;
    import mx.rpc.AbstractOperation;

    use namespace mx_internal;

    public dynamic class RemoteObject extends AbstractService 
    {

        private var _concurrency:String;
        private var _endpoint:String;
        private var _source:String;
        private var _makeObjectsBindable:Boolean;
        private var _showBusyCursor:Boolean;
        public var convertParametersHandler:Function;
        public var convertResultHandler:Function;

        public function RemoteObject(_arg1:String=null)
        {
            super(_arg1);
            this.concurrency = Concurrency.MULTIPLE;
            this.makeObjectsBindable = true;
            this.showBusyCursor = false;
        }

        public function get concurrency():String
        {
            return (this._concurrency);
        }

        public function set concurrency(_arg1:String):void
        {
            this._concurrency = _arg1;
        }

        public function get endpoint():String
        {
            return (this._endpoint);
        }

        public function set endpoint(_arg1:String):void
        {
            if (((!((this._endpoint == _arg1))) || ((_arg1 == null))))
            {
                this._endpoint = _arg1;
                channelSet = null;
            };
        }

        public function get makeObjectsBindable():Boolean
        {
            return (this._makeObjectsBindable);
        }

        public function set makeObjectsBindable(_arg1:Boolean):void
        {
            this._makeObjectsBindable = _arg1;
        }

        public function get showBusyCursor():Boolean
        {
            return (this._showBusyCursor);
        }

        public function set showBusyCursor(_arg1:Boolean):void
        {
            this._showBusyCursor = _arg1;
        }

        public function get source():String
        {
            return (this._source);
        }

        public function set source(_arg1:String):void
        {
            this._source = _arg1;
        }

        mx_internal function initEndpoint():void
        {
            var _local1:Channel;
            if (this.endpoint != null)
            {
                if (this.endpoint.indexOf("https") == 0)
                {
                    _local1 = new SecureAMFChannel(null, this.endpoint);
                }
                else
                {
                    _local1 = new AMFChannel(null, this.endpoint);
                };
                _local1.requestTimeout = requestTimeout;
                channelSet = new ChannelSet();
                channelSet.addChannel(_local1);
            };
        }

        override public function getOperation(_arg1:String):AbstractOperation
        {
            var _local2:AbstractOperation = super.getOperation(_arg1);
            if (_local2 == null)
            {
                _local2 = new Operation(this, _arg1);
                _operations[_arg1] = _local2;
                _local2.asyncRequest = asyncRequest;
            };
            return (_local2);
        }

        override public function setRemoteCredentials(_arg1:String, _arg2:String, _arg3:String=null):void
        {
            super.setRemoteCredentials(_arg1, _arg2, _arg3);
        }

        public function toString():String
        {
            var _local1 = "[RemoteObject ";
            _local1 = (_local1 + ((' destination="' + destination) + '"'));
            if (this.source)
            {
                _local1 = (_local1 + ((' source="' + this.source) + '"'));
            };
            _local1 = (_local1 + ((' channelSet="' + channelSet) + '"]'));
            return (_local1);
        }


    }
}//package mx.rpc.remoting
