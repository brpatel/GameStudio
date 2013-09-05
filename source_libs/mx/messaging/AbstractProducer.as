//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import mx.messaging.messages.CommandMessage;
    import flash.utils.Timer;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.events.PropertyChangeEvent;
    import mx.messaging.messages.AcknowledgeMessage;
    import mx.messaging.messages.IMessage;
    import mx.core.mx_internal;
    import mx.messaging.messages.ErrorMessage;
    import mx.messaging.events.ChannelEvent;
    import mx.messaging.events.ChannelFaultEvent;
    import mx.logging.Log;
    import flash.events.TimerEvent;

    use namespace mx_internal;

    public class AbstractProducer extends MessageAgent 
    {

        private var _connectMsg:CommandMessage;
        private var _currentAttempt:int;
        private var _reconnectTimer:Timer;
        protected var _shouldBeConnected:Boolean;
        private var resourceManager:IResourceManager;
        private var _autoConnect:Boolean = true;
        private var _defaultHeaders:Object;
        private var _priority:int = -1;
        private var _reconnectAttempts:int;
        private var _reconnectInterval:int;

        public function AbstractProducer()
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
        }

        [Bindable(event="propertyChange")]
        public function get autoConnect():Boolean
        {
            return (this._autoConnect);
        }

        public function set autoConnect(_arg1:Boolean):void
        {
            var _local2:PropertyChangeEvent;
            if (this._autoConnect != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "autoConnect", this._autoConnect, _arg1);
                this._autoConnect = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get defaultHeaders():Object
        {
            return (this._defaultHeaders);
        }

        public function set defaultHeaders(_arg1:Object):void
        {
            var _local2:PropertyChangeEvent;
            if (this._defaultHeaders != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "defaultHeaders", this._defaultHeaders, _arg1);
                this._defaultHeaders = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get priority():int
        {
            return (this._priority);
        }

        public function set priority(_arg1:int):void
        {
            var _local2:PropertyChangeEvent;
            if (this._priority != _arg1)
            {
                _arg1 = (((_arg1 < 0)) ? 0 : (((_arg1 > 9)) ? 9 : _arg1));
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "priority", this._priority, _arg1);
                this._priority = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get reconnectAttempts():int
        {
            return (this._reconnectAttempts);
        }

        public function set reconnectAttempts(_arg1:int):void
        {
            var _local2:PropertyChangeEvent;
            if (this._reconnectAttempts != _arg1)
            {
                if (_arg1 == 0)
                {
                    this.stopReconnectTimer();
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "reconnectAttempts", this._reconnectAttempts, _arg1);
                this._reconnectAttempts = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get reconnectInterval():int
        {
            return (this._reconnectInterval);
        }

        public function set reconnectInterval(_arg1:int):void
        {
            var _local2:PropertyChangeEvent;
            var _local3:String;
            if (this._reconnectInterval != _arg1)
            {
                if (_arg1 < 0)
                {
                    _local3 = this.resourceManager.getString("messaging", "reconnectIntervalNegative");
                    throw (new ArgumentError(_local3));
                };
                if (_arg1 == 0)
                {
                    this.stopReconnectTimer();
                }
                else
                {
                    if (this._reconnectTimer != null)
                    {
                        this._reconnectTimer.delay = _arg1;
                    };
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "reconnectInterval", this._reconnectInterval, _arg1);
                this._reconnectInterval = _arg1;
                dispatchEvent(_local2);
            };
        }

        override public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void
        {
            if (_disconnectBarrier)
            {
                return;
            };
            super.acknowledge(_arg1, _arg2);
            if ((((_arg2 is CommandMessage)) && ((CommandMessage(_arg2).operation == CommandMessage.TRIGGER_CONNECT_OPERATION))))
            {
                this.stopReconnectTimer();
            };
        }

        override public function fault(_arg1:ErrorMessage, _arg2:IMessage):void
        {
            this.internalFault(_arg1, _arg2);
        }

        override public function channelDisconnectHandler(_arg1:ChannelEvent):void
        {
            super.channelDisconnectHandler(_arg1);
            if (((this._shouldBeConnected) && (!(_arg1.rejected))))
            {
                this.startReconnectTimer();
            };
        }

        override public function channelFaultHandler(_arg1:ChannelFaultEvent):void
        {
            super.channelFaultHandler(_arg1);
            if (((((this._shouldBeConnected) && (!(_arg1.rejected)))) && (!(_arg1.channel.connected))))
            {
                this.startReconnectTimer();
            };
        }

        override public function disconnect():void
        {
            this._shouldBeConnected = false;
            this.stopReconnectTimer();
            super.disconnect();
        }

        public function connect():void
        {
            if (!connected)
            {
                this._shouldBeConnected = true;
                if (this._connectMsg == null)
                {
                    this._connectMsg = this.buildConnectMessage();
                };
                internalSend(this._connectMsg, false);
            };
        }

        public function send(_arg1:IMessage):void
        {
            var _local2:String;
            var _local3:ErrorMessage;
            if (((!(connected)) && (this.autoConnect)))
            {
                this._shouldBeConnected = true;
            };
            if (this.defaultHeaders != null)
            {
                for (_local2 in this.defaultHeaders)
                {
                    if (!_arg1.headers.hasOwnProperty(_local2))
                    {
                        _arg1.headers[_local2] = this.defaultHeaders[_local2];
                    };
                };
            };
            if (((!(connected)) && (!(this.autoConnect))))
            {
                this._shouldBeConnected = false;
                _local3 = new ErrorMessage();
                _local3.faultCode = "Client.Error.MessageSend";
                _local3.faultString = this.resourceManager.getString("messaging", "producerSendError");
                _local3.faultDetail = this.resourceManager.getString("messaging", "producerSendErrorDetails");
                _local3.correlationId = _arg1.messageId;
                this.internalFault(_local3, _arg1, false, true);
            }
            else
            {
                if (Log.isInfo())
                {
                    _log.info("'{0}' {1} sending message '{2}'", id, _agentType, _arg1.messageId);
                };
                internalSend(_arg1);
            };
        }

        mx_internal function internalFault(_arg1:ErrorMessage, _arg2:IMessage, _arg3:Boolean=true, _arg4:Boolean=false):void
        {
            var _local5:ErrorMessage;
            if (((_disconnectBarrier) && (!(_arg4))))
            {
                return;
            };
            if ((((_arg2 is CommandMessage)) && ((CommandMessage(_arg2).operation == CommandMessage.TRIGGER_CONNECT_OPERATION))))
            {
                if (this._reconnectTimer == null)
                {
                    if (((!((this._connectMsg == null))) && ((_arg1.correlationId == this._connectMsg.messageId))))
                    {
                        this._shouldBeConnected = false;
                        _local5 = this.buildConnectErrorMessage();
                        _local5.rootCause = _arg1.rootCause;
                        super.fault(_local5, _arg2);
                    }
                    else
                    {
                        super.fault(_arg1, _arg2);
                    };
                };
            }
            else
            {
                super.fault(_arg1, _arg2);
            };
        }

        protected function reconnect(_arg1:TimerEvent):void
        {
            if (((!((this._reconnectAttempts == -1))) && ((this._currentAttempt >= this._reconnectAttempts))))
            {
                this.stopReconnectTimer();
                this._shouldBeConnected = false;
                this.fault(this.buildConnectErrorMessage(), this._connectMsg);
                return;
            };
            if (Log.isDebug())
            {
                _log.debug("'{0}' {1} trying to reconnect.", id, _agentType);
            };
            this._reconnectTimer.delay = this._reconnectInterval;
            this._currentAttempt++;
            if (this._connectMsg == null)
            {
                this._connectMsg = this.buildConnectMessage();
            };
            internalSend(this._connectMsg, false);
        }

        protected function startReconnectTimer():void
        {
            if (((this._shouldBeConnected) && ((this._reconnectTimer == null))))
            {
                if (((!((this._reconnectAttempts == 0))) && ((this._reconnectInterval > 0))))
                {
                    if (Log.isDebug())
                    {
                        _log.debug("'{0}' {1} starting reconnect timer.", id, _agentType);
                    };
                    this._reconnectTimer = new Timer(1);
                    this._reconnectTimer.addEventListener(TimerEvent.TIMER, this.reconnect);
                    this._reconnectTimer.start();
                    this._currentAttempt = 0;
                };
            };
        }

        protected function stopReconnectTimer():void
        {
            if (this._reconnectTimer != null)
            {
                if (Log.isDebug())
                {
                    _log.debug("'{0}' {1} stopping reconnect timer.", id, _agentType);
                };
                this._reconnectTimer.removeEventListener(TimerEvent.TIMER, this.reconnect);
                this._reconnectTimer.reset();
                this._reconnectTimer = null;
            };
        }

        private function buildConnectErrorMessage():ErrorMessage
        {
            var _local1:ErrorMessage = new ErrorMessage();
            _local1.faultCode = "Client.Error.Connect";
            _local1.faultString = this.resourceManager.getString("messaging", "producerConnectError");
            _local1.faultDetail = this.resourceManager.getString("messaging", "failedToConnect");
            _local1.correlationId = this._connectMsg.messageId;
            return (_local1);
        }

        private function buildConnectMessage():CommandMessage
        {
            var _local1:CommandMessage = new CommandMessage();
            _local1.operation = CommandMessage.TRIGGER_CONNECT_OPERATION;
            _local1.clientId = clientId;
            _local1.destination = destination;
            return (_local1);
        }


    }
}//package mx.messaging
