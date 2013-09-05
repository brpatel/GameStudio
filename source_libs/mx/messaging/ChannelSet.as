//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.core.mx_internal;
    import mx.events.PropertyChangeEvent;
    import flash.errors.IllegalOperationError;
    import mx.messaging.events.ChannelEvent;
    import mx.messaging.events.ChannelFaultEvent;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.messages.AcknowledgeMessage;
    import mx.messaging.channels.NetConnectionChannel;
    import flash.events.TimerEvent;
    import mx.utils.Base64Encoder;
    import mx.rpc.AsyncToken;
    import mx.messaging.channels.PollingChannel;
    import mx.rpc.AsyncDispatcher;
    import mx.messaging.messages.IMessage;
    import mx.rpc.events.ResultEvent;
    import mx.messaging.events.MessageFaultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.messaging.messages.ErrorMessage;
    import mx.messaging.events.MessageEvent;
    import mx.rpc.events.AbstractEvent;
    import mx.messaging.errors.NoChannelAvailableError;
    import mx.messaging.config.ServerConfig;

    use namespace mx_internal;

    public class ChannelSet extends EventDispatcher 
    {

        private var _authAgent:AuthenticationAgent;
        private var _connecting:Boolean;
        private var _credentials:String;
        private var _credentialsCharset:String;
        private var _currentChannelIndex:int;
        private var _hasRequestedClusterEndpoints:Boolean;
        private var _heartbeatTimer:Timer;
        private var _hunting:Boolean;
        private var _pendingMessages:Dictionary;
        private var _pendingSends:Array;
        private var _reconnectTimer:Timer = null;
        private var _shouldBeConnected:Boolean;
        private var _shouldHunt:Boolean;
        private var resourceManager:IResourceManager;
        private var _authenticated:Boolean;
        private var _channels:Array;
        private var _channelIds:Array;
        private var _currentChannel:Channel;
        private var _channelFailoverURIs:Object;
        private var _configured:Boolean;
        private var _connected:Boolean;
        private var _clustered:Boolean;
        private var _heartbeatInterval:int = 0;
        private var _initialDestinationId:String;
        private var _messageAgents:Array;

        public function ChannelSet(_arg1:Array=null, _arg2:Boolean=false)
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this._clustered = _arg2;
            this._connected = false;
            this._connecting = false;
            this._currentChannelIndex = -1;
            if (_arg1 != null)
            {
                this._channelIds = _arg1;
                this._channels = new Array(this._channelIds.length);
                this._configured = true;
            }
            else
            {
                this._channels = [];
                this._configured = false;
            };
            this._hasRequestedClusterEndpoints = false;
            this._hunting = false;
            this._messageAgents = [];
            this._pendingMessages = new Dictionary();
            this._pendingSends = [];
            this._shouldBeConnected = false;
            this._shouldHunt = true;
        }

        [Bindable(event="propertyChange")]
        public function get authenticated():Boolean
        {
            return (this._authenticated);
        }

        mx_internal function setAuthenticated(_arg1:Boolean, _arg2:String, _arg3:Boolean=true):void
        {
            var _local4:PropertyChangeEvent;
            var _local5:MessageAgent;
            var _local6:int;
            if (this._authenticated != _arg1)
            {
                _local4 = PropertyChangeEvent.createUpdateEvent(this, "authenticated", this._authenticated, _arg1);
                this._authenticated = _arg1;
                if (_arg3)
                {
                    _local6 = 0;
                    while (_local6 < this._messageAgents.length)
                    {
                        _local5 = MessageAgent(this._messageAgents[_local6]);
                        _local5.setAuthenticated(_arg1, _arg2);
                        _local6++;
                    };
                };
                if (((!(_arg1)) && (!((this._authAgent == null)))))
                {
                    this._authAgent.state = AuthenticationAgent.LOGGED_OUT_STATE;
                };
                dispatchEvent(_local4);
            };
        }

        public function get channels():Array
        {
            return (this._channels);
        }

        public function set channels(_arg1:Array):void
        {
            var _local5:String;
            var _local6:int;
            var _local7:int;
            if (this.configured)
            {
                _local5 = this.resourceManager.getString("messaging", "cannotAddWhenConfigured");
                throw (new IllegalOperationError(_local5));
            };
            var _local2:Array = this._channels.slice();
            var _local3:int = _local2.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                this.removeChannel(_local2[_local4]);
                _local4++;
            };
            if (((!((_arg1 == null))) && ((_arg1.length > 0))))
            {
                _local6 = _arg1.length;
                _local7 = 0;
                while (_local7 < _local6)
                {
                    this.addChannel(_arg1[_local7]);
                    _local7++;
                };
            };
        }

        public function get channelIds():Array
        {
            var _local1:Array;
            var _local2:int;
            var _local3:int;
            if (this._channelIds != null)
            {
                return (this._channelIds);
            };
            _local1 = [];
            _local2 = this._channels.length;
            _local3 = 0;
            while (_local3 < _local2)
            {
                if (this._channels[_local3] != null)
                {
                    _local1.push(this._channels[_local3].id);
                }
                else
                {
                    _local1.push(null);
                };
                _local3++;
            };
            return (_local1);
        }

        public function get currentChannel():Channel
        {
            return (this._currentChannel);
        }

        mx_internal function get channelFailoverURIs():Object
        {
            return (this._channelFailoverURIs);
        }

        mx_internal function set channelFailoverURIs(_arg1:Object):void
        {
            var _local4:Channel;
            this._channelFailoverURIs = _arg1;
            var _local2:int = this._channels.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                _local4 = this._channels[_local3];
                if (_local4 == null) break;
                if (this._channelFailoverURIs[_local4.id] != null)
                {
                    _local4.failoverURIs = this._channelFailoverURIs[_local4.id];
                };
                _local3++;
            };
        }

        mx_internal function get configured():Boolean
        {
            return (this._configured);
        }

        [Bindable(event="propertyChange")]
        public function get connected():Boolean
        {
            return (this._connected);
        }

        protected function setConnected(_arg1:Boolean):void
        {
            var _local2:PropertyChangeEvent;
            if (this._connected != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "connected", this._connected, _arg1);
                this._connected = _arg1;
                dispatchEvent(_local2);
                this.setAuthenticated(((((_arg1) && (this.currentChannel))) && (this.currentChannel.authenticated)), this._credentials, false);
                if (!this.connected)
                {
                    this.unscheduleHeartbeat();
                }
                else
                {
                    if (this.heartbeatInterval > 0)
                    {
                        this.scheduleHeartbeat();
                    };
                };
            };
        }

        public function get clustered():Boolean
        {
            return (this._clustered);
        }

        public function set clustered(_arg1:Boolean):void
        {
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:String;
            if (this._clustered != _arg1)
            {
                if (_arg1)
                {
                    _local2 = this.channelIds;
                    _local3 = _local2.length;
                    _local4 = 0;
                    while (_local4 < _local3)
                    {
                        if (_local2[_local4] == null)
                        {
                            _local5 = this.resourceManager.getString("messaging", "cannotSetClusteredWithdNullChannelIds");
                            throw (new IllegalOperationError(_local5));
                        };
                        _local4++;
                    };
                };
                this._clustered = _arg1;
            };
        }

        public function get heartbeatInterval():int
        {
            return (this._heartbeatInterval);
        }

        public function set heartbeatInterval(_arg1:int):void
        {
            var _local2:PropertyChangeEvent;
            if (this._heartbeatInterval != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "heartbeatInterval", this._heartbeatInterval, _arg1);
                this._heartbeatInterval = _arg1;
                dispatchEvent(_local2);
                if ((((this._heartbeatInterval > 0)) && (this.connected)))
                {
                    this.scheduleHeartbeat();
                };
            };
        }

        public function get initialDestinationId():String
        {
            return (this._initialDestinationId);
        }

        public function set initialDestinationId(_arg1:String):void
        {
            this._initialDestinationId = _arg1;
        }

        public function get messageAgents():Array
        {
            return (this._messageAgents);
        }

        override public function toString():String
        {
            var _local1 = "[ChannelSet ";
            var _local2:uint;
            while (_local2 < this._channels.length)
            {
                if (this._channels[_local2] != null)
                {
                    _local1 = (_local1 + (this._channels[_local2].id + " "));
                };
                _local2++;
            };
            _local1 = (_local1 + "]");
            return (_local1);
        }

        public function addChannel(_arg1:Channel):void
        {
            var _local2:String;
            if (_arg1 == null)
            {
                return;
            };
            if (this.configured)
            {
                _local2 = this.resourceManager.getString("messaging", "cannotAddWhenConfigured");
                throw (new IllegalOperationError(_local2));
            };
            if (((this.clustered) && ((_arg1.id == null))))
            {
                _local2 = this.resourceManager.getString("messaging", "cannotAddNullIdChannelWhenClustered");
                throw (new IllegalOperationError(_local2));
            };
            if (this._channels.indexOf(_arg1) != -1)
            {
                return;
            };
            this._channels.push(_arg1);
            if (this._credentials)
            {
                _arg1.setCredentials(this._credentials, null, this._credentialsCharset);
            };
        }

        public function removeChannel(_arg1:Channel):void
        {
            var _local3:String;
            if (this.configured)
            {
                _local3 = this.resourceManager.getString("messaging", "cannotRemoveWhenConfigured");
                throw (new IllegalOperationError(_local3));
            };
            var _local2:int = this._channels.indexOf(_arg1);
            if (_local2 > -1)
            {
                this._channels.splice(_local2, 1);
                if (((!((this._currentChannel == null))) && ((this._currentChannel == _arg1))))
                {
                    if (this.connected)
                    {
                        this._shouldHunt = false;
                        this.disconnectChannel();
                    };
                    this._currentChannel = null;
                    this._currentChannelIndex = -1;
                };
            };
        }

        public function connect(_arg1:MessageAgent):void
        {
            if (((!((_arg1 == null))) && ((this._messageAgents.indexOf(_arg1) == -1))))
            {
                this._shouldBeConnected = true;
                this._messageAgents.push(_arg1);
                _arg1.internalSetChannelSet(this);
                addEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler);
                addEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler);
                addEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler);
                if (((this.connected) && (!(_arg1.needsConfig))))
                {
                    _arg1.channelConnectHandler(ChannelEvent.createEvent(ChannelEvent.CONNECT, this._currentChannel, false, false, this.connected));
                };
            };
        }

        public function disconnect(_arg1:MessageAgent):void
        {
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:PendingSend;
            if (_arg1 == null)
            {
                _local2 = this._messageAgents.slice();
                _local3 = _local2.length;
                _local4 = 0;
                while (_local4 < _local3)
                {
                    _local2[_local4].disconnect();
                    _local4++;
                };
                if (this._authAgent != null)
                {
                    this._authAgent.state = AuthenticationAgent.SHUTDOWN_STATE;
                    this._authAgent = null;
                };
            }
            else
            {
                _local5 = (((_arg1)!=null) ? this._messageAgents.indexOf(_arg1) : -1);
                if (_local5 != -1)
                {
                    this._messageAgents.splice(_local5, 1);
                    removeEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler);
                    removeEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler);
                    removeEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler);
                    if (((this.connected) || (this._connecting)))
                    {
                        _arg1.channelDisconnectHandler(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, this._currentChannel, false));
                    }
                    else
                    {
                        _local6 = this._pendingSends.length;
                        _local7 = 0;
                        while (_local7 < _local6)
                        {
                            _local8 = PendingSend(this._pendingSends[_local7]);
                            if (_local8.agent == _arg1)
                            {
                                this._pendingSends.splice(_local7, 1);
                                _local7--;
                                _local6--;
                                delete this._pendingMessages[_local8.message];
                            };
                            _local7++;
                        };
                    };
                    if (this._messageAgents.length == 0)
                    {
                        this._shouldBeConnected = false;
                        this._currentChannelIndex = -1;
                        if (this.connected)
                        {
                            this.disconnectChannel();
                        };
                    };
                    if (_arg1.channelSetMode == MessageAgent.AUTO_CONFIGURED_CHANNELSET)
                    {
                        _arg1.internalSetChannelSet(null);
                    };
                };
            };
        }

        public function disconnectAll():void
        {
            this.disconnect(null);
        }

        public function channelConnectHandler(_arg1:ChannelEvent):void
        {
            var _local3:PendingSend;
            var _local4:CommandMessage;
            var _local5:AcknowledgeMessage;
            this._connecting = false;
            this._connected = true;
            this._currentChannelIndex = -1;
            while (this._pendingSends.length > 0)
            {
                _local3 = PendingSend(this._pendingSends.shift());
                delete this._pendingMessages[_local3.message];
                _local4 = (_local3.message as CommandMessage);
                if (_local4 != null)
                {
                    if (_local4.operation == CommandMessage.TRIGGER_CONNECT_OPERATION)
                    {
                        _local5 = new AcknowledgeMessage();
                        _local5.clientId = _local3.agent.clientId;
                        _local5.correlationId = _local4.messageId;
                        _local3.agent.acknowledge(_local5, _local4);
                        continue;
                    };
                    if (((((!(_local3.agent.configRequested)) && (_local3.agent.needsConfig))) && ((_local4.operation == CommandMessage.CLIENT_PING_OPERATION))))
                    {
                        _local4.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
                        _local3.agent.configRequested = true;
                    };
                };
                this.send(_local3.agent, _local3.message);
            };
            if (this._hunting)
            {
                _arg1.reconnecting = true;
                this._hunting = false;
            };
            dispatchEvent(_arg1);
            var _local2:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "connected", false, true);
            dispatchEvent(_local2);
        }

        public function channelDisconnectHandler(_arg1:ChannelEvent):void
        {
            this._connecting = false;
            this.setConnected(false);
            if (((((this._shouldBeConnected) && (!(_arg1.reconnecting)))) && (!(_arg1.rejected))))
            {
                if (((this._shouldHunt) && (this.hunt())))
                {
                    _arg1.reconnecting = true;
                    dispatchEvent(_arg1);
                    if ((this._currentChannel is NetConnectionChannel))
                    {
                        if (this._reconnectTimer == null)
                        {
                            this._reconnectTimer = new Timer(1, 1);
                            this._reconnectTimer.addEventListener(TimerEvent.TIMER, this.reconnectChannel);
                            this._reconnectTimer.start();
                        };
                    }
                    else
                    {
                        this.connectChannel();
                    };
                }
                else
                {
                    dispatchEvent(_arg1);
                    this.faultPendingSends(_arg1);
                };
            }
            else
            {
                dispatchEvent(_arg1);
                if (_arg1.rejected)
                {
                    this.faultPendingSends(_arg1);
                };
            };
            this._shouldHunt = true;
        }

        public function channelFaultHandler(_arg1:ChannelFaultEvent):void
        {
            if (_arg1.channel.connected)
            {
                dispatchEvent(_arg1);
            }
            else
            {
                this._connecting = false;
                this.setConnected(false);
                if (((((this._shouldBeConnected) && (!(_arg1.reconnecting)))) && (!(_arg1.rejected))))
                {
                    if (this.hunt())
                    {
                        _arg1.reconnecting = true;
                        dispatchEvent(_arg1);
                        if ((this._currentChannel is NetConnectionChannel))
                        {
                            if (this._reconnectTimer == null)
                            {
                                this._reconnectTimer = new Timer(1, 1);
                                this._reconnectTimer.addEventListener(TimerEvent.TIMER, this.reconnectChannel);
                                this._reconnectTimer.start();
                            };
                        }
                        else
                        {
                            this.connectChannel();
                        };
                    }
                    else
                    {
                        dispatchEvent(_arg1);
                        this.faultPendingSends(_arg1);
                    };
                }
                else
                {
                    dispatchEvent(_arg1);
                    if (_arg1.rejected)
                    {
                        this.faultPendingSends(_arg1);
                    };
                };
            };
        }

        public function login(_arg1:String, _arg2:String, _arg3:String=null):AsyncToken
        {
            var _local7:String;
            var _local8:Base64Encoder;
            if (this.authenticated)
            {
                throw (new IllegalOperationError("ChannelSet is already authenticated."));
            };
            if (((!((this._authAgent == null))) && (!((this._authAgent.state == AuthenticationAgent.LOGGED_OUT_STATE)))))
            {
                throw (new IllegalOperationError("ChannelSet is in the process of logging in or logging out."));
            };
            if (_arg3 != Base64Encoder.CHARSET_UTF_8)
            {
                _arg3 = null;
            };
            var _local4:String;
            if (((!((_arg1 == null))) && (!((_arg2 == null)))))
            {
                _local7 = ((_arg1 + ":") + _arg2);
                _local8 = new Base64Encoder();
                if (_arg3 == Base64Encoder.CHARSET_UTF_8)
                {
                    _local8.encodeUTFBytes(_local7);
                }
                else
                {
                    _local8.encode(_local7);
                };
                _local4 = _local8.drain();
            };
            var _local5:CommandMessage = new CommandMessage();
            _local5.operation = CommandMessage.LOGIN_OPERATION;
            _local5.body = _local4;
            if (_arg3 != null)
            {
                _local5.headers[CommandMessage.CREDENTIALS_CHARSET_HEADER] = _arg3;
            };
            _local5.destination = "auth";
            var _local6:AsyncToken = new AsyncToken(_local5);
            if (this._authAgent == null)
            {
                this._authAgent = new AuthenticationAgent(this);
            };
            this._authAgent.registerToken(_local6);
            this._authAgent.state = AuthenticationAgent.LOGGING_IN_STATE;
            this.send(this._authAgent, _local5);
            return (_local6);
        }

        public function logout(_arg1:MessageAgent=null):AsyncToken
        {
            var _local2:int;
            var _local3:int;
            var _local4:CommandMessage;
            var _local5:AsyncToken;
            var _local6:int;
            var _local7:int;
            this._credentials = null;
            if (_arg1 == null)
            {
                if (((!((this._authAgent == null))) && ((((this._authAgent.state == AuthenticationAgent.LOGGING_OUT_STATE)) || ((this._authAgent.state == AuthenticationAgent.LOGGING_IN_STATE))))))
                {
                    throw (new IllegalOperationError("ChannelSet is in the process of logging in or logging out."));
                };
                _local2 = this._messageAgents.length;
                _local3 = 0;
                while (_local3 < _local2)
                {
                    this._messageAgents[_local3].internalSetCredentials(null);
                    _local3++;
                };
                _local2 = this._channels.length;
                _local3 = 0;
                while (_local3 < _local2)
                {
                    if (this._channels[_local3] != null)
                    {
                        this._channels[_local3].internalSetCredentials(null);
                        if ((this._channels[_local3] is PollingChannel))
                        {
                            PollingChannel(this._channels[_local3]).disablePolling();
                        };
                    };
                    _local3++;
                };
                _local4 = new CommandMessage();
                _local4.operation = CommandMessage.LOGOUT_OPERATION;
                _local4.destination = "auth";
                _local5 = new AsyncToken(_local4);
                if (this._authAgent == null)
                {
                    this._authAgent = new AuthenticationAgent(this);
                };
                this._authAgent.registerToken(_local5);
                this._authAgent.state = AuthenticationAgent.LOGGING_OUT_STATE;
                this.send(this._authAgent, _local4);
                return (_local5);
            };
            _local6 = this._channels.length;
            _local7 = 0;
            while (_local7 < _local6)
            {
                if (this._channels[_local7] != null)
                {
                    this._channels[_local7].logout(_arg1);
                };
                _local7++;
            };
            return (null);
        }

        public function send(_arg1:MessageAgent, _arg2:IMessage):void
        {
            var _local3:AcknowledgeMessage;
            var _local4:CommandMessage;
            if (((!((this._currentChannel == null))) && (this._currentChannel.connected)))
            {
                if ((((((_arg2 is CommandMessage)) && ((CommandMessage(_arg2).operation == CommandMessage.TRIGGER_CONNECT_OPERATION)))) && (!(_arg1.needsConfig))))
                {
                    _local3 = new AcknowledgeMessage();
                    _local3.clientId = _arg1.clientId;
                    _local3.correlationId = _arg2.messageId;
                    new AsyncDispatcher(_arg1.acknowledge, [_local3, _arg2], 1);
                    return;
                };
                if (((!(this._hasRequestedClusterEndpoints)) && (this.clustered)))
                {
                    _local4 = new CommandMessage();
                    if ((_arg1 is AuthenticationAgent))
                    {
                        _local4.destination = this.initialDestinationId;
                    }
                    else
                    {
                        _local4.destination = _arg1.destination;
                    };
                    _local4.operation = CommandMessage.CLUSTER_REQUEST_OPERATION;
                    this._currentChannel.sendInternalMessage(new ClusterMessageResponder(_local4, this));
                    this._hasRequestedClusterEndpoints = true;
                };
                this.unscheduleHeartbeat();
                this._currentChannel.send(_arg1, _arg2);
                this.scheduleHeartbeat();
            }
            else
            {
                if (this._pendingMessages[_arg2] == null)
                {
                    this._pendingMessages[_arg2] = true;
                    this._pendingSends.push(new PendingSend(_arg1, _arg2));
                };
                if (!this._connecting)
                {
                    if ((((this._currentChannel == null)) || ((this._currentChannelIndex == -1))))
                    {
                        this.hunt();
                    };
                    if ((this._currentChannel is NetConnectionChannel))
                    {
                        if (this._reconnectTimer == null)
                        {
                            this._reconnectTimer = new Timer(1, 1);
                            this._reconnectTimer.addEventListener(TimerEvent.TIMER, this.reconnectChannel);
                            this._reconnectTimer.start();
                        };
                    }
                    else
                    {
                        this.connectChannel();
                    };
                };
            };
        }

        public function setCredentials(_arg1:String, _arg2:MessageAgent, _arg3:String=null):void
        {
            this._credentials = _arg1;
            var _local4:int = this._channels.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                if (this._channels[_local5] != null)
                {
                    this._channels[_local5].setCredentials(this._credentials, _arg2, _arg3);
                };
                _local5++;
            };
        }

        mx_internal function authenticationSuccess(_arg1:AuthenticationAgent, _arg2:AsyncToken, _arg3:AcknowledgeMessage):void
        {
            var _local9:int;
            var _local10:int;
            var _local4:CommandMessage = CommandMessage(_arg2.message);
            var _local5 = (_local4.operation == CommandMessage.LOGIN_OPERATION);
            var _local6:String = ((_local5) ? String(_local4.body) : null);
            var _local7:Number = 0;
            if (_local5)
            {
                this._credentials = _local6;
                _local9 = this._messageAgents.length;
                _local10 = 0;
                while (_local10 < _local9)
                {
                    this._messageAgents[_local10].internalSetCredentials(_local6);
                    _local10++;
                };
                _local9 = this._channels.length;
                _local10 = 0;
                while (_local10 < _local9)
                {
                    if (this._channels[_local10] != null)
                    {
                        this._channels[_local10].internalSetCredentials(_local6);
                    };
                    _local10++;
                };
                _arg1.state = AuthenticationAgent.LOGGED_IN_STATE;
                this.currentChannel.setAuthenticated(true);
            }
            else
            {
                _arg1.state = AuthenticationAgent.SHUTDOWN_STATE;
                this._authAgent = null;
                _local7 = 250;
                this.disconnect(_arg1);
                this.currentChannel.setAuthenticated(false);
            };
            var _local8:ResultEvent = ResultEvent.createEvent(_arg3.body, _arg2, _arg3);
            if (_local7 > 0)
            {
                new AsyncDispatcher(this.dispatchRPCEvent, [_local8], _local7);
            }
            else
            {
                this.dispatchRPCEvent(_local8);
            };
        }

        mx_internal function authenticationFailure(_arg1:AuthenticationAgent, _arg2:AsyncToken, _arg3:ErrorMessage):void
        {
            var _local4:MessageFaultEvent = MessageFaultEvent.createEvent(_arg3);
            var _local5:FaultEvent = FaultEvent.createEventFromMessageFault(_local4, _arg2);
            _arg1.state = AuthenticationAgent.SHUTDOWN_STATE;
            this._authAgent = null;
            this.disconnect(_arg1);
            this.dispatchRPCEvent(_local5);
        }

        protected function faultPendingSends(_arg1:ChannelEvent):void
        {
            var _local2:PendingSend;
            var _local3:IMessage;
            var _local4:ErrorMessage;
            var _local5:ChannelFaultEvent;
            while (this._pendingSends.length > 0)
            {
                _local2 = (this._pendingSends.shift() as PendingSend);
                _local3 = _local2.message;
                delete this._pendingMessages[_local3];
                _local4 = new ErrorMessage();
                _local4.correlationId = _local3.messageId;
                _local4.headers[ErrorMessage.RETRYABLE_HINT_HEADER] = true;
                _local4.faultCode = "Client.Error.MessageSend";
                _local4.faultString = this.resourceManager.getString("messaging", "sendFailed");
                if ((_arg1 is ChannelFaultEvent))
                {
                    _local5 = (_arg1 as ChannelFaultEvent);
                    _local4.faultDetail = ((((_local5.faultCode + " ") + _local5.faultString) + " ") + _local5.faultDetail);
                    if (_local5.faultCode == "Channel.Authentication.Error")
                    {
                        _local4.faultCode = _local5.faultCode;
                    };
                }
                else
                {
                    _local4.faultDetail = this.resourceManager.getString("messaging", "cannotConnectToDestination");
                };
                _local4.rootCause = _arg1;
                _local2.agent.fault(_local4, _local3);
            };
        }

        protected function messageHandler(_arg1:MessageEvent):void
        {
            dispatchEvent(_arg1);
        }

        protected function scheduleHeartbeat():void
        {
            if ((((this._heartbeatTimer == null)) && ((this.heartbeatInterval > 0))))
            {
                this._heartbeatTimer = new Timer(this.heartbeatInterval, 1);
                this._heartbeatTimer.addEventListener(TimerEvent.TIMER, this.sendHeartbeatHandler);
                this._heartbeatTimer.start();
            };
        }

        protected function sendHeartbeatHandler(_arg1:TimerEvent):void
        {
            this.unscheduleHeartbeat();
            if (this.currentChannel != null)
            {
                this.sendHeartbeat();
                this.scheduleHeartbeat();
            };
        }

        protected function sendHeartbeat():void
        {
            var _local1:PollingChannel = (this.currentChannel as PollingChannel);
            if (((!((_local1 == null))) && (_local1._shouldPoll)))
            {
                return;
            };
            var _local2:CommandMessage = new CommandMessage();
            _local2.operation = CommandMessage.CLIENT_PING_OPERATION;
            _local2.headers[CommandMessage.HEARTBEAT_HEADER] = true;
            this.currentChannel.sendInternalMessage(new MessageResponder(null, _local2));
        }

        protected function unscheduleHeartbeat():void
        {
            if (this._heartbeatTimer != null)
            {
                this._heartbeatTimer.stop();
                this._heartbeatTimer.removeEventListener(TimerEvent.TIMER, this.sendHeartbeatHandler);
                this._heartbeatTimer = null;
            };
        }

        private function connectChannel():void
        {
            this._connecting = true;
            this._currentChannel.connect(this);
            this._currentChannel.addEventListener(MessageEvent.MESSAGE, this.messageHandler);
        }

        private function disconnectChannel():void
        {
            this._connecting = false;
            this._currentChannel.removeEventListener(MessageEvent.MESSAGE, this.messageHandler);
            this._currentChannel.disconnect(this);
        }

        private function dispatchRPCEvent(_arg1:AbstractEvent):void
        {
            _arg1.callTokenResponders();
            dispatchEvent(_arg1);
        }

        private function hunt():Boolean
        {
            var _local1:String;
            if (this._channels.length == 0)
            {
                _local1 = this.resourceManager.getString("messaging", "noAvailableChannels");
                throw (new NoChannelAvailableError(_local1));
            };
            if (this._currentChannel != null)
            {
                this.disconnectChannel();
            };
            if (++this._currentChannelIndex >= this._channels.length)
            {
                this._currentChannelIndex = -1;
                return (false);
            };
            if (this._currentChannelIndex > 0)
            {
                this._hunting = true;
            };
            if (this.configured)
            {
                if (this._channels[this._currentChannelIndex] != null)
                {
                    this._currentChannel = this._channels[this._currentChannelIndex];
                }
                else
                {
                    this._currentChannel = ServerConfig.getChannel(this._channelIds[this._currentChannelIndex], this._clustered);
                    this._currentChannel.setCredentials(this._credentials);
                    this._channels[this._currentChannelIndex] = this._currentChannel;
                };
            }
            else
            {
                this._currentChannel = this._channels[this._currentChannelIndex];
            };
            if (((!((this._channelFailoverURIs == null))) && (!((this._channelFailoverURIs[this._currentChannel.id] == null)))))
            {
                this._currentChannel.failoverURIs = this._channelFailoverURIs[this._currentChannel.id];
            };
            return (true);
        }

        private function reconnectChannel(_arg1:TimerEvent):void
        {
            this._reconnectTimer.stop();
            this._reconnectTimer.removeEventListener(TimerEvent.TIMER, this.reconnectChannel);
            this._reconnectTimer = null;
            this.connectChannel();
        }


    }
}//package mx.messaging

import mx.messaging.MessageResponder;
import mx.messaging.ChannelSet;
import mx.messaging.messages.IMessage;
import mx.collections.ArrayCollection;
import mx.core.mx_internal;
import mx.messaging.MessageAgent;
import mx.logging.Log;
import mx.rpc.AsyncToken;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.events.ChannelEvent;
import mx.messaging.messages.ErrorMessage;

use namespace mx_internal;

class ClusterMessageResponder extends MessageResponder 
{

    private var _channelSet:ChannelSet;

    public function ClusterMessageResponder(_arg1:IMessage, _arg2:ChannelSet)
    {
        super(null, _arg1);
        this._channelSet = _arg2;
    }

    override protected function resultHandler(_arg1:IMessage):void
    {
        var _local2:Object;
        var _local3:Array;
        var _local4:int;
        var _local5:int;
        var _local6:Object;
        var _local7:Object;
        if (((!((_arg1.body == null))) && ((((_arg1.body is Array)) || ((_arg1.body is ArrayCollection))))))
        {
            _local2 = {};
            _local3 = (((_arg1.body is Array)) ? (_arg1.body as Array) : (_arg1.body as ArrayCollection).toArray());
            _local4 = _local3.length;
            _local5 = 0;
            while (_local5 < _local4)
            {
                _local6 = _local3[_local5];
                for (_local7 in _local6)
                {
                    if (_local2[_local7] == null)
                    {
                        _local2[_local7] = [];
                    };
                    _local2[_local7].push(_local6[_local7]);
                };
                _local5++;
            };
            this._channelSet.channelFailoverURIs = _local2;
        };
    }


}
class PendingSend 
{

    public var agent:MessageAgent;
    public var message:IMessage;

    public function PendingSend(_arg1:MessageAgent, _arg2:IMessage)
    {
        this.agent = _arg1;
        this.message = _arg2;
    }

}
class AuthenticationAgent extends MessageAgent 
{

    public static const LOGGED_OUT_STATE:int = 0;
    public static const LOGGING_IN_STATE:int = 1;
    public static const LOGGED_IN_STATE:int = 2;
    public static const LOGGING_OUT_STATE:int = 3;
    public static const SHUTDOWN_STATE:int = 4;

    private var tokens:Object;
    private var _state:int = 0;

    public function AuthenticationAgent(_arg1:ChannelSet)
    {
        this.tokens = {};
        super();
        _log = Log.getLogger("ChannelSet.AuthenticationAgent");
        _agentType = "authentication agent";
        this.channelSet = _arg1;
    }

    public function get state():int
    {
        return (this._state);
    }

    public function set state(_arg1:int):void
    {
        this._state = _arg1;
        if (_arg1 == SHUTDOWN_STATE)
        {
            this.tokens = null;
        };
    }

    public function registerToken(_arg1:AsyncToken):void
    {
        this.tokens[_arg1.message.messageId] = _arg1;
    }

    override public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void
    {
        var _local4:AsyncToken;
        if (this.state == SHUTDOWN_STATE)
        {
            return;
        };
        var _local3:Boolean = _arg1.headers[AcknowledgeMessage.ERROR_HINT_HEADER];
        super.acknowledge(_arg1, _arg2);
        if (!_local3)
        {
            _local4 = this.tokens[_arg2.messageId];
            delete this.tokens[_arg2.messageId];
            channelSet.authenticationSuccess(this, _local4, (_arg1 as AcknowledgeMessage));
        };
    }

    override public function fault(_arg1:ErrorMessage, _arg2:IMessage):void
    {
        var _local4:AcknowledgeMessage;
        if (this.state == SHUTDOWN_STATE)
        {
            return;
        };
        if ((((_arg1.rootCause is ChannelEvent)) && (((_arg1.rootCause as ChannelEvent).type == ChannelEvent.DISCONNECT))))
        {
            _local4 = new AcknowledgeMessage();
            _local4.clientId = clientId;
            _local4.correlationId = _arg2.messageId;
            this.acknowledge(_local4, _arg2);
            return;
        };
        super.fault(_arg1, _arg2);
        var _local3:AsyncToken = this.tokens[_arg2.messageId];
        delete this.tokens[_arg2.messageId];
        channelSet.authenticationFailure(this, _local3, (_arg1 as ErrorMessage));
    }


}
