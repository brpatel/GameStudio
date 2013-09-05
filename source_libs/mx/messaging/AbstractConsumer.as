//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import flash.utils.Timer;
    import mx.messaging.messages.CommandMessage;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.logging.Log;
    import mx.core.mx_internal;
    import mx.events.PropertyChangeEvent;
    import mx.messaging.channels.PollingChannel;
    import mx.messaging.messages.IMessage;
    import mx.messaging.messages.AcknowledgeMessage;
    import mx.messaging.events.MessageEvent;
    import mx.messaging.messages.ErrorMessage;
    import mx.messaging.events.ChannelEvent;
    import mx.messaging.events.ChannelFaultEvent;
    import mx.messaging.events.MessageFaultEvent;
    import flash.events.TimerEvent;

    use namespace mx_internal;

    public class AbstractConsumer extends MessageAgent 
    {

        private var _currentAttempt:int;
        private var _resubscribeTimer:Timer;
        protected var _shouldBeSubscribed:Boolean;
        private var _subscribeMsg:CommandMessage;
        private var resourceManager:IResourceManager;
        private var _maxFrequency:uint = 0;
        private var _resubscribeAttempts:int = 5;
        private var _resubscribeInterval:int = 5000;
        private var _subscribed:Boolean;
        private var _timestamp:Number = -1;

        public function AbstractConsumer()
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            _log = Log.getLogger("mx.messaging.Consumer");
            _agentType = "consumer";
        }

        override mx_internal function setClientId(_arg1:String):void
        {
            var _local2:Boolean;
            if (super.clientId != _arg1)
            {
                _local2 = false;
                if (this.subscribed)
                {
                    this.unsubscribe();
                    _local2 = true;
                };
                super.setClientId(_arg1);
                if (_local2)
                {
                    this.subscribe(_arg1);
                };
            };
        }

        override public function set destination(_arg1:String):void
        {
            var _local2:Boolean;
            if (destination != _arg1)
            {
                _local2 = false;
                if (this.subscribed)
                {
                    this.unsubscribe();
                    _local2 = true;
                };
                super.destination = _arg1;
                if (_local2)
                {
                    this.subscribe();
                };
            };
        }

        [Bindable(event="propertyChange")]
        public function get maxFrequency():uint
        {
            return (this._maxFrequency);
        }

        public function set maxFrequency(_arg1:uint):void
        {
            var _local2:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "maxFrequency", this._maxFrequency, _arg1);
            this._maxFrequency = _arg1;
            dispatchEvent(_local2);
        }

        [Bindable(event="propertyChange")]
        public function get resubscribeAttempts():int
        {
            return (this._resubscribeAttempts);
        }

        public function set resubscribeAttempts(_arg1:int):void
        {
            var _local2:PropertyChangeEvent;
            if (this._resubscribeAttempts != _arg1)
            {
                if (_arg1 == 0)
                {
                    this.stopResubscribeTimer();
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "resubscribeAttempts", this._resubscribeAttempts, _arg1);
                this._resubscribeAttempts = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get resubscribeInterval():int
        {
            return (this._resubscribeInterval);
        }

        public function set resubscribeInterval(_arg1:int):void
        {
            var _local2:PropertyChangeEvent;
            var _local3:String;
            if (this._resubscribeInterval != _arg1)
            {
                if (_arg1 < 0)
                {
                    _local3 = this.resourceManager.getString("messaging", "resubscribeIntervalNegative");
                    throw (new ArgumentError(_local3));
                };
                if (_arg1 == 0)
                {
                    this.stopResubscribeTimer();
                }
                else
                {
                    if (this._resubscribeTimer != null)
                    {
                        this._resubscribeTimer.delay = _arg1;
                    };
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "resubscribeInterval", this._resubscribeInterval, _arg1);
                this._resubscribeInterval = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get subscribed():Boolean
        {
            return (this._subscribed);
        }

        protected function setSubscribed(_arg1:Boolean):void
        {
            var _local2:PropertyChangeEvent;
            if (this._subscribed != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "subscribed", this._subscribed, _arg1);
                this._subscribed = _arg1;
                if (this._subscribed)
                {
                    ConsumerMessageDispatcher.getInstance().registerSubscription(this);
                    if (((((!((channelSet == null))) && (!((channelSet.currentChannel == null))))) && ((channelSet.currentChannel is PollingChannel))))
                    {
                        PollingChannel(channelSet.currentChannel).enablePolling();
                    };
                }
                else
                {
                    ConsumerMessageDispatcher.getInstance().unregisterSubscription(this);
                    if (((((!((channelSet == null))) && (!((channelSet.currentChannel == null))))) && ((channelSet.currentChannel is PollingChannel))))
                    {
                        PollingChannel(channelSet.currentChannel).disablePolling();
                    };
                };
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get timestamp():Number
        {
            return (this._timestamp);
        }

        public function set timestamp(_arg1:Number):void
        {
            var _local2:PropertyChangeEvent;
            if (this._timestamp != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "timestamp", this._timestamp, _arg1);
                this._timestamp = _arg1;
                dispatchEvent(_local2);
            };
        }

        override public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void
        {
            var _local3:CommandMessage;
            var _local4:int;
            var _local5:Array;
            var _local6:IMessage;
            if (_disconnectBarrier)
            {
                return;
            };
            if (((!(_arg1.headers[AcknowledgeMessage.ERROR_HINT_HEADER])) && ((_arg2 is CommandMessage))))
            {
                _local3 = (_arg2 as CommandMessage);
                _local4 = _local3.operation;
                if (_local4 == CommandMessage.MULTI_SUBSCRIBE_OPERATION)
                {
                    if (_arg2.headers.DSlastUnsub != null)
                    {
                        _local4 = CommandMessage.UNSUBSCRIBE_OPERATION;
                    }
                    else
                    {
                        _local4 = CommandMessage.SUBSCRIBE_OPERATION;
                    };
                };
                switch (_local4)
                {
                    case CommandMessage.UNSUBSCRIBE_OPERATION:
                        if (Log.isInfo())
                        {
                            _log.info("'{0}' {1} acknowledge for unsubscribe.", id, _agentType);
                        };
                        super.setClientId(null);
                        this.setSubscribed(false);
                        _arg1.clientId = null;
                        super.acknowledge(_arg1, _arg2);
                        break;
                    case CommandMessage.SUBSCRIBE_OPERATION:
                        this.stopResubscribeTimer();
                        if (_arg1.timestamp > this._timestamp)
                        {
                            this._timestamp = (_arg1.timestamp - 1);
                        };
                        if (Log.isInfo())
                        {
                            _log.info("'{0}' {1} acknowledge for subscribe. Client id '{2}' new timestamp {3}", id, _agentType, _arg1.clientId, this._timestamp);
                        };
                        super.setClientId(_arg1.clientId);
                        this.setSubscribed(true);
                        super.acknowledge(_arg1, _arg2);
                        break;
                    case CommandMessage.POLL_OPERATION:
                        if (((!((_arg1.body == null))) && ((_arg1.body is Array))))
                        {
                            _local5 = (_arg1.body as Array);
                            for each (_local6 in _local5)
                            {
                                this.messageHandler(MessageEvent.createEvent(MessageEvent.MESSAGE, _local6));
                            };
                        };
                        super.acknowledge(_arg1, _arg2);
                        break;
                };
            }
            else
            {
                super.acknowledge(_arg1, _arg2);
            };
        }

        override public function disconnect():void
        {
            this._shouldBeSubscribed = false;
            this.stopResubscribeTimer();
            this.setSubscribed(false);
            super.disconnect();
        }

        override public function fault(_arg1:ErrorMessage, _arg2:IMessage):void
        {
            if (_disconnectBarrier)
            {
                return;
            };
            if (_arg1.headers[ErrorMessage.RETRYABLE_HINT_HEADER])
            {
                if (this._resubscribeTimer == null)
                {
                    if (((!((this._subscribeMsg == null))) && ((_arg1.correlationId == this._subscribeMsg.messageId))))
                    {
                        this._shouldBeSubscribed = false;
                    };
                    super.fault(_arg1, _arg2);
                };
            }
            else
            {
                super.fault(_arg1, _arg2);
            };
        }

        override public function channelConnectHandler(_arg1:ChannelEvent):void
        {
            super.channelConnectHandler(_arg1);
            if (((((((((connected) && (!((channelSet == null))))) && (!((channelSet.currentChannel == null))))) && (!(channelSet.currentChannel.realtime)))) && (Log.isWarn())))
            {
                _log.warn(("'{0}' {1} connected over a non-realtime channel '{2}'" + " which means channel is not automatically receiving updates via polling or server push."), id, _agentType, channelSet.currentChannel.id);
            };
        }

        override public function channelDisconnectHandler(_arg1:ChannelEvent):void
        {
            this.setSubscribed(false);
            super.channelDisconnectHandler(_arg1);
            if (((this._shouldBeSubscribed) && (!(_arg1.rejected))))
            {
                this.startResubscribeTimer();
            };
        }

        override public function channelFaultHandler(_arg1:ChannelFaultEvent):void
        {
            if (!_arg1.channel.connected)
            {
                this.setSubscribed(false);
            };
            super.channelFaultHandler(_arg1);
            if (((((this._shouldBeSubscribed) && (!(_arg1.rejected)))) && (!(_arg1.channel.connected))))
            {
                this.startResubscribeTimer();
            };
        }

        public function receive(_arg1:Number=0):void
        {
            var _local2:CommandMessage;
            if (clientId != null)
            {
                _local2 = new CommandMessage();
                _local2.operation = CommandMessage.POLL_OPERATION;
                _local2.destination = destination;
                internalSend(_local2);
            };
        }

        public function subscribe(_arg1:String=null):void
        {
            var _local2:Boolean = ((((!((_arg1 == null))) && (!((super.clientId == _arg1))))) ? true : false);
            if (((this.subscribed) && (_local2)))
            {
                this.unsubscribe();
            };
            this.stopResubscribeTimer();
            this._shouldBeSubscribed = true;
            if (_local2)
            {
                super.setClientId(_arg1);
            };
            if (Log.isInfo())
            {
                _log.info("'{0}' {1} subscribe.", id, _agentType);
            };
            this._subscribeMsg = this.buildSubscribeMessage();
            internalSend(this._subscribeMsg);
        }

        public function unsubscribe(_arg1:Boolean=false):void
        {
            this._shouldBeSubscribed = false;
            if (this.subscribed)
            {
                if (channelSet != null)
                {
                    channelSet.removeEventListener(destination, this.messageHandler);
                };
                if (Log.isInfo())
                {
                    _log.info("'{0}' {1} unsubscribe.", id, _agentType);
                };
                internalSend(this.buildUnsubscribeMessage(_arg1));
            }
            else
            {
                this.stopResubscribeTimer();
            };
        }

        mx_internal function messageHandler(_arg1:MessageEvent):void
        {
            var _local3:CommandMessage;
            var _local2:IMessage = _arg1.message;
            if ((_local2 is CommandMessage))
            {
                _local3 = (_local2 as CommandMessage);
                switch (_local3.operation)
                {
                    case CommandMessage.SUBSCRIPTION_INVALIDATE_OPERATION:
                        this.setSubscribed(false);
                        return;
                    default:
                        if (Log.isWarn())
                        {
                            _log.warn("'{0}' received a CommandMessage '{1}' that could not be handled.", id, CommandMessage.getOperationAsString(_local3.operation));
                        };
                };
                return;
            };
            if (_local2.timestamp > this._timestamp)
            {
                this._timestamp = _local2.timestamp;
            };
            if ((_local2 is ErrorMessage))
            {
                dispatchEvent(MessageFaultEvent.createEvent(ErrorMessage(_local2)));
            }
            else
            {
                dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE, _local2));
            };
        }

        protected function buildSubscribeMessage():CommandMessage
        {
            var _local1:CommandMessage = new CommandMessage();
            _local1.operation = CommandMessage.SUBSCRIBE_OPERATION;
            _local1.clientId = clientId;
            _local1.destination = destination;
            if (this.maxFrequency > 0)
            {
                _local1.headers[CommandMessage.MAX_FREQUENCY_HEADER] = this.maxFrequency;
            };
            return (_local1);
        }

        protected function buildUnsubscribeMessage(_arg1:Boolean):CommandMessage
        {
            var _local2:CommandMessage = new CommandMessage();
            _local2.operation = CommandMessage.UNSUBSCRIBE_OPERATION;
            _local2.clientId = clientId;
            _local2.destination = destination;
            if (_arg1)
            {
                _local2.headers[CommandMessage.PRESERVE_DURABLE_HEADER] = _arg1;
            };
            return (_local2);
        }

        protected function resubscribe(_arg1:TimerEvent):void
        {
            var _local2:ErrorMessage;
            if (((!((this._resubscribeAttempts == -1))) && ((this._currentAttempt >= this._resubscribeAttempts))))
            {
                this.stopResubscribeTimer();
                this._shouldBeSubscribed = false;
                _local2 = new ErrorMessage();
                _local2.faultCode = "Client.Error.Subscribe";
                _local2.faultString = this.resourceManager.getString("messaging", "consumerSubscribeError");
                _local2.faultDetail = this.resourceManager.getString("messaging", "failedToSubscribe");
                _local2.correlationId = this._subscribeMsg.messageId;
                this.fault(_local2, this._subscribeMsg);
                return;
            };
            if (Log.isDebug())
            {
                _log.debug("'{0}' {1} trying to resubscribe.", id, _agentType);
            };
            this._resubscribeTimer.delay = this._resubscribeInterval;
            this._currentAttempt++;
            internalSend(this._subscribeMsg, false);
        }

        protected function startResubscribeTimer():void
        {
            if (((this._shouldBeSubscribed) && ((this._resubscribeTimer == null))))
            {
                if (((!((this._resubscribeAttempts == 0))) && ((this._resubscribeInterval > 0))))
                {
                    if (Log.isDebug())
                    {
                        _log.debug("'{0}' {1} starting resubscribe timer.", id, _agentType);
                    };
                    this._resubscribeTimer = new Timer(1);
                    this._resubscribeTimer.addEventListener(TimerEvent.TIMER, this.resubscribe);
                    this._resubscribeTimer.start();
                    this._currentAttempt = 0;
                };
            };
        }

        protected function stopResubscribeTimer():void
        {
            if (this._resubscribeTimer != null)
            {
                if (Log.isDebug())
                {
                    _log.debug("'{0}' {1} stopping resubscribe timer.", id, _agentType);
                };
                this._resubscribeTimer.removeEventListener(TimerEvent.TIMER, this.resubscribe);
                this._resubscribeTimer.reset();
                this._resubscribeTimer = null;
            };
        }


    }
}//package mx.messaging
