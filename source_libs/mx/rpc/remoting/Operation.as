//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc.remoting
{
    import mx.rpc.AbstractOperation;
    import mx.resources.IResourceManager;
    import mx.core.mx_internal;
    import mx.resources.ResourceManager;
    import mx.rpc.AbstractService;
    import mx.rpc.AsyncToken;
    import mx.rpc.Fault;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.mxml.Concurrency;
    import mx.rpc.AsyncDispatcher;
    import mx.messaging.messages.RemotingMessage;
    import mx.managers.CursorManager;
    import mx.messaging.messages.IMessage;
    import mx.messaging.messages.AsyncMessage;
    import mx.messaging.events.MessageEvent;

    use namespace mx_internal;

    public class Operation extends AbstractOperation 
    {

        public var argumentNames:Array;
        private var _concurrency:String;
        private var _concurrencySet:Boolean;
        private var _makeObjectsBindableSet:Boolean;
        private var _showBusyCursor:Boolean;
        private var _showBusyCursorSet:Boolean;
        private var resourceManager:IResourceManager;
        mx_internal var remoteObject:RemoteObject;

        public function Operation(_arg1:AbstractService=null, _arg2:String=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super(_arg1, _arg2);
            this.argumentNames = [];
            this.remoteObject = RemoteObject(_arg1);
        }

        public function get concurrency():String
        {
            if (this._concurrencySet)
            {
                return (this._concurrency);
            };
            return (this.remoteObject.concurrency);
        }

        public function set concurrency(_arg1:String):void
        {
            this._concurrency = _arg1;
            this._concurrencySet = true;
        }

        override public function get makeObjectsBindable():Boolean
        {
            if (this._makeObjectsBindableSet)
            {
                return (_makeObjectsBindable);
            };
            return (RemoteObject(service).makeObjectsBindable);
        }

        override public function set makeObjectsBindable(_arg1:Boolean):void
        {
            _makeObjectsBindable = _arg1;
            this._makeObjectsBindableSet = true;
        }

        public function get showBusyCursor():Boolean
        {
            if (this._showBusyCursorSet)
            {
                return (this._showBusyCursor);
            };
            return (this.remoteObject.showBusyCursor);
        }

        public function set showBusyCursor(_arg1:Boolean):void
        {
            this._showBusyCursor = _arg1;
            this._showBusyCursorSet = true;
        }

        override public function send(... _args):AsyncToken
        {
            var _local3:AsyncToken;
            var _local4:String;
            var _local5:Fault;
            var _local6:FaultEvent;
            var _local7:int;
            if (service != null)
            {
                service.initialize();
            };
            if (this.remoteObject.convertParametersHandler != null)
            {
                var _local1:Array = this.remoteObject.convertParametersHandler(_args);
            };
            if (operationManager != null)
            {
                return (operationManager(_args));
            };
            if ((((Concurrency.SINGLE == this.concurrency)) && (activeCalls.hasActiveCalls())))
            {
                _local3 = new AsyncToken(null);
                _local4 = this.resourceManager.getString("rpc", "pendingCallExists");
                _local5 = new Fault("ConcurrencyError", _local4);
                _local6 = FaultEvent.createEvent(_local5, _local3);
                new AsyncDispatcher(dispatchRpcEvent, [_local6], 10);
                return (_local3);
            };
            if ((((asyncRequest.channelSet == null)) && (!((this.remoteObject.endpoint == null)))))
            {
                this.remoteObject.initEndpoint();
            };
            if (((!(_args)) || ((((_args.length == 0)) && (this.arguments)))))
            {
                if ((this.arguments is Array))
                {
                    _local1 = (this.arguments as Array);
                }
                else
                {
                    _local1 = [];
                    _local7 = 0;
                    while (_local7 < this.argumentNames.length)
                    {
                        _local1[_local7] = this.arguments[this.argumentNames[_local7]];
                        _local7++;
                    };
                };
            };
            var _local2:RemotingMessage = new RemotingMessage();
            _local2.operation = name;
            _local2.body = _args;
            _local2.source = RemoteObject(service).source;
            return (this.invoke(_local2));
        }

        override public function cancel(_arg1:String=null):AsyncToken
        {
            if (this.showBusyCursor)
            {
                CursorManager.removeBusyCursor();
            };
            return (super.cancel(_arg1));
        }

        override mx_internal function setService(_arg1:AbstractService):void
        {
            super.setService(_arg1);
            this.remoteObject = RemoteObject(_arg1);
        }

        override mx_internal function invoke(_arg1:IMessage, _arg2:AsyncToken=null):AsyncToken
        {
            if (this.showBusyCursor)
            {
                CursorManager.setBusyCursor();
            };
            return (super.invoke(_arg1, _arg2));
        }

        override mx_internal function preHandle(_arg1:MessageEvent):AsyncToken
        {
            if (this.showBusyCursor)
            {
                CursorManager.removeBusyCursor();
            };
            var _local2:Boolean = activeCalls.wasLastCall(AsyncMessage(_arg1.message).correlationId);
            var _local3:AsyncToken = super.preHandle(_arg1);
            if ((((Concurrency.LAST == this.concurrency)) && (!(_local2))))
            {
                return (null);
            };
            return (_local3);
        }

        override mx_internal function processResult(_arg1:IMessage, _arg2:AsyncToken):Boolean
        {
            if (super.processResult(_arg1, _arg2))
            {
                if (this.remoteObject.convertResultHandler != null)
                {
                    _result = this.remoteObject.convertResultHandler(_result, this);
                };
                return (true);
            };
            return (false);
        }


    }
}//package mx.rpc.remoting
