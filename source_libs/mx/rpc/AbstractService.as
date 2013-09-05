//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    import flash.utils.Proxy;
    import mx.resources.IResourceManager;
    import mx.core.mx_internal;
    import flash.events.EventDispatcher;
    import mx.resources.ResourceManager;
    import mx.messaging.ChannelSet;
    import flash.events.Event;
    import mx.rpc.events.AbstractEvent;
    import flash.events.*;
    import flash.utils.flash_proxy

    use namespace mx_internal;

    [Bindable(event="operationsChange")]
    public dynamic class AbstractService extends Proxy implements IEventDispatcher 
    {

        private var resourceManager:IResourceManager;
        private var _managers:Array;
        mx_internal var _operations:Object;
        private var nextNameArray:Array;
        mx_internal var _availableChannelIds:Array;
        mx_internal var asyncRequest:AsyncRequest;
        private var eventDispatcher:EventDispatcher;
        private var _initialized:Boolean = false;

        public function AbstractService(_arg1:String=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this.eventDispatcher = new EventDispatcher(this);
            this.asyncRequest = new AsyncRequest();
            if (_arg1)
            {
                this.destination = _arg1;
                this.asyncRequest.destination = _arg1;
            };
            this._operations = {};
        }

        public function get channelSet():ChannelSet
        {
            return (this.asyncRequest.channelSet);
        }

        public function set channelSet(_arg1:ChannelSet):void
        {
            if (this.channelSet != _arg1)
            {
                this.asyncRequest.channelSet = _arg1;
            };
        }

        public function get destination():String
        {
            return (this.asyncRequest.destination);
        }

        public function set destination(_arg1:String):void
        {
            this.asyncRequest.destination = _arg1;
        }

        public function get managers():Array
        {
            return (this._managers);
        }

        public function set managers(_arg1:Array):void
        {
            var _local2:int;
            var _local3:Object;
            if (this._managers != null)
            {
                _local2 = 0;
                while (_local2 < this._managers.length)
                {
                    _local3 = this._managers[_local2];
                    if (_local3.hasOwnProperty("service"))
                    {
                        _local3.service = null;
                    };
                    _local2++;
                };
            };
            this._managers = _arg1;
            _local2 = 0;
            while (_local2 < _arg1.length)
            {
                _local3 = this._managers[_local2];
                if (_local3.hasOwnProperty("service"))
                {
                    _local3.service = this;
                };
                if (((this._initialized) && (_local3.hasOwnProperty("initialize"))))
                {
                    _local3.initialize();
                };
                _local2++;
            };
        }

        public function get operations():Object
        {
            return (this._operations);
        }

        public function set operations(_arg1:Object):void
        {
            var _local2:AbstractOperation;
            var _local3:String;
            for (_local3 in _arg1)
            {
                _local2 = AbstractOperation(_arg1[_local3]);
                _local2.setService(this);
                if (!_local2.name)
                {
                    _local2.name = _local3;
                };
                _local2.asyncRequest = this.asyncRequest;
            };
            this._operations = _arg1;
            this.dispatchEvent(new Event("operationsChange"));
        }

        public function get requestTimeout():int
        {
            return (this.asyncRequest.requestTimeout);
        }

        public function set requestTimeout(_arg1:int):void
        {
            if (this.requestTimeout != _arg1)
            {
                this.asyncRequest.requestTimeout = _arg1;
            };
        }

        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void
        {
            this.eventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }

        public function dispatchEvent(_arg1:Event):Boolean
        {
            return (this.eventDispatcher.dispatchEvent(_arg1));
        }

        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void
        {
            this.eventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }

        public function hasEventListener(_arg1:String):Boolean
        {
            return (this.eventDispatcher.hasEventListener(_arg1));
        }

        public function willTrigger(_arg1:String):Boolean
        {
            return (this.eventDispatcher.willTrigger(_arg1));
        }

        public function initialize():void
        {
            var _local1:int;
            var _local2:Object;
            if (((!(this._initialized)) && (!((this._managers == null)))))
            {
                _local1 = 0;
                while (_local1 < this._managers.length)
                {
                    _local2 = this._managers[_local1];
                    if (_local2.hasOwnProperty("initialize"))
                    {
                        _local2.initialize();
                    };
                    _local1++;
                };
                this._initialized = true;
            };
        }

        override flash_proxy function getProperty(_arg1)
        {
            return (this.getOperation(this.getLocalName(_arg1)));
        }

        override flash_proxy function setProperty(_arg1, _arg2):void
        {
            var _local3:String = this.resourceManager.getString("rpc", "operationsNotAllowedInService", [this.getLocalName(_arg1)]);
            throw (new Error(_local3));
        }

        override flash_proxy function callProperty(_arg1, ... _args)
        {
            return (this.getOperation(this.getLocalName(_arg1)).send.apply(null, _args));
        }

        override flash_proxy function nextNameIndex(_arg1:int):int
        {
            var _local2:String;
            if (_arg1 == 0)
            {
                this.nextNameArray = [];
                for (_local2 in this._operations)
                {
                    this.nextNameArray.push(_local2);
                };
            };
            return ((((_arg1 < this.nextNameArray.length)) ? (_arg1 + 1) : 0));
        }

        override flash_proxy function nextName(_arg1:int):String
        {
            return (this.nextNameArray[(_arg1 - 1)]);
        }

        override flash_proxy function nextValue(_arg1:int)
        {
            return (this._operations[this.nextNameArray[(_arg1 - 1)]]);
        }

        mx_internal function getLocalName(_arg1:Object):String
        {
            if ((_arg1 is QName))
            {
                return (QName(_arg1).localName);
            };
            return (String(_arg1));
        }

        public function getOperation(_arg1:String):AbstractOperation
        {
            var _local2:Object = this._operations[_arg1];
            var _local3:AbstractOperation = (((_local2 is AbstractOperation)) ? AbstractOperation(_local2) : null);
            return (_local3);
        }

        public function disconnect():void
        {
            this.asyncRequest.disconnect();
        }

        public function setCredentials(_arg1:String, _arg2:String, _arg3:String=null):void
        {
            this.asyncRequest.setCredentials(_arg1, _arg2, _arg3);
        }

        public function logout():void
        {
            this.asyncRequest.logout();
        }

        public function setRemoteCredentials(_arg1:String, _arg2:String, _arg3:String=null):void
        {
            this.asyncRequest.setRemoteCredentials(_arg1, _arg2, _arg3);
        }

        public function valueOf():Object
        {
            return (this);
        }

        mx_internal function hasTokenResponders(_arg1:Event):Boolean
        {
            var _local2:AbstractEvent;
            if ((_arg1 is AbstractEvent))
            {
                _local2 = (_arg1 as AbstractEvent);
                if (((!((_local2.token == null))) && (_local2.token.hasResponder())))
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}//package mx.rpc
