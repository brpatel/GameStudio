//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.messaging.events.ChannelEvent;
    import mx.logging.ILogger;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.utils.UIDUtil;
    import mx.events.PropertyChangeEvent;
    import mx.logging.Log;
    import mx.messaging.messages.MessagePerformanceUtils;
    import mx.messaging.messages.AcknowledgeMessage;
    import mx.messaging.messages.IMessage;
    import mx.messaging.config.ServerConfig;
    import mx.messaging.config.ConfigMap;
    import mx.messaging.events.MessageAckEvent;
    import mx.messaging.messages.ErrorMessage;
    import mx.messaging.events.MessageFaultEvent;
    import mx.messaging.events.ChannelFaultEvent;
    import mx.utils.Base64Encoder;
    import mx.messaging.channels.PollingChannel;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.messages.AbstractMessage;
    import mx.messaging.errors.InvalidDestinationError;
    import mx.netmon.NetworkMonitor;
    import mx.messaging.events.MessageEvent;
    import mx.core.*;

    use namespace mx_internal;

    public class MessageAgent extends EventDispatcher implements IMXMLObject 
    {

        mx_internal static const AUTO_CONFIGURED_CHANNELSET:int = 0;
        mx_internal static const MANUALLY_ASSIGNED_CHANNELSET:int = 1;

        protected var _agentType:String = "mx.messaging.MessageAgent";
        protected var _credentials:String;
        protected var _credentialsCharset:String;
        protected var _disconnectBarrier:Boolean;
        private var _pendingConnectEvent:ChannelEvent;
        private var _remoteCredentials:String = "";
        private var _remoteCredentialsCharset:String;
        private var _sendRemoteCredentials:Boolean;
        protected var _log:ILogger;
        private var _clientIdWaitQueue:Array;
        protected var _ignoreFault:Boolean = false;
        private var resourceManager:IResourceManager;
        private var _authenticated:Boolean;
        private var _channelSet:ChannelSet;
        private var _clientId:String;
        private var _connected:Boolean = false;
        private var _destination:String = "";
        private var _id:String;
        private var _requestTimeout:int = -1;
        private var _channelSetMode:int = 0;
        mx_internal var configRequested:Boolean = false;
        private var _needsConfig:Boolean;

        public function MessageAgent()
        {
            this.resourceManager = ResourceManager.getInstance();
            this._id = UIDUtil.createUID();
            super();
        }

        [Bindable(event="propertyChange")]
        public function get authenticated():Boolean
        {
            return (this._authenticated);
        }

        mx_internal function setAuthenticated(_arg1:Boolean, _arg2:String):void
        {
            var _local3:PropertyChangeEvent;
            if (this._authenticated != _arg1)
            {
                _local3 = PropertyChangeEvent.createUpdateEvent(this, "authenticated", this._authenticated, _arg1);
                this._authenticated = _arg1;
                dispatchEvent(_local3);
                if (_arg1)
                {
                    this.assertCredentials(_arg2);
                };
            };
        }

        [Bindable(event="propertyChange")]
        public function get channelSet():ChannelSet
        {
            return (this._channelSet);
        }

        public function set channelSet(_arg1:ChannelSet):void
        {
            this.internalSetChannelSet(_arg1);
            this._channelSetMode = MANUALLY_ASSIGNED_CHANNELSET;
        }

        mx_internal function internalSetChannelSet(_arg1:ChannelSet):void
        {
            var _local2:PropertyChangeEvent;
            if (this._channelSet != _arg1)
            {
                if (this._channelSet != null)
                {
                    this._channelSet.disconnect(this);
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "channelSet", this._channelSet, _arg1);
                this._channelSet = _arg1;
                if (this._channelSet != null)
                {
                    if (this._credentials)
                    {
                        this._channelSet.setCredentials(this._credentials, this, this._credentialsCharset);
                    };
                    this._channelSet.connect(this);
                };
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get clientId():String
        {
            return (this._clientId);
        }

        mx_internal function setClientId(_arg1:String):void
        {
            var _local2:PropertyChangeEvent;
            if (this._clientId != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "clientId", this._clientId, _arg1);
                this._clientId = _arg1;
                this.flushClientIdWaitQueue();
                dispatchEvent(_local2);
            };
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
                this.setAuthenticated(((((_arg1) && (this.channelSet))) && (this.channelSet.authenticated)), this._credentials);
            };
        }

        [Bindable(event="propertyChange")]
        public function get destination():String
        {
            return (this._destination);
        }

        public function set destination(_arg1:String):void
        {
            var _local2:PropertyChangeEvent;
            if ((((_arg1 == null)) || ((_arg1.length == 0))))
            {
                return;
            };
            if (this._destination != _arg1)
            {
                if ((((this._channelSetMode == AUTO_CONFIGURED_CHANNELSET)) && (!((this.channelSet == null)))))
                {
                    this.channelSet.disconnect(this);
                    this.channelSet = null;
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "destination", this._destination, _arg1);
                this._destination = _arg1;
                dispatchEvent(_local2);
                if (Log.isInfo())
                {
                    this._log.info("'{0}' {2} set destination to '{1}'.", this.id, this._destination, this._agentType);
                };
            };
        }

        [Bindable(event="propertyChange")]
        public function get id():String
        {
            return (this._id);
        }

        public function set id(_arg1:String):void
        {
            var _local2:PropertyChangeEvent;
            if (this._id != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "id", this._id, _arg1);
                this._id = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        public function get requestTimeout():int
        {
            return (this._requestTimeout);
        }

        public function set requestTimeout(_arg1:int):void
        {
            var _local2:PropertyChangeEvent;
            if (this._requestTimeout != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "requestTimeout", this._requestTimeout, _arg1);
                this._requestTimeout = _arg1;
                dispatchEvent(_local2);
            };
        }

        mx_internal function get channelSetMode():int
        {
            return (this._channelSetMode);
        }

        mx_internal function get needsConfig():Boolean
        {
            return (this._needsConfig);
        }

        mx_internal function set needsConfig(_arg1:Boolean):void
        {
            var cs:ChannelSet;
            var value:Boolean = _arg1;
            if (this._needsConfig == value)
            {
                return;
            };
            this._needsConfig = value;
            if (this._needsConfig)
            {
                cs = this.channelSet;
                try
                {
                    this.disconnect();
                }
                finally
                {
                    this.internalSetChannelSet(cs);
                };
            };
        }

        public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void
        {
            var mpiutil:MessagePerformanceUtils;
            var ackMsg:AcknowledgeMessage = _arg1;
            var msg:IMessage = _arg2;
            if (Log.isInfo())
            {
                this._log.info("'{0}' {2} acknowledge of '{1}'.", this.id, msg.messageId, this._agentType);
            };
            if (((((Log.isDebug()) && (this.isCurrentChannelNotNull()))) && (this.getCurrentChannel().mpiEnabled)))
            {
                try
                {
                    mpiutil = new MessagePerformanceUtils(ackMsg);
                    this._log.debug(mpiutil.prettyPrint());
                }
                catch(e:Error)
                {
                    _log.debug(("Could not get message performance information for: " + msg.toString()));
                };
            };
            if (this.configRequested)
            {
                this.configRequested = false;
                ServerConfig.updateServerConfigData((ackMsg.body as ConfigMap));
                this.needsConfig = false;
                if (this._pendingConnectEvent)
                {
                    this.channelConnectHandler(this._pendingConnectEvent);
                };
                this._pendingConnectEvent = null;
            };
            if (this.clientId == null)
            {
                if (ackMsg.clientId != null)
                {
                    this.setClientId(ackMsg.clientId);
                }
                else
                {
                    this.flushClientIdWaitQueue();
                };
            };
            dispatchEvent(MessageAckEvent.createEvent(ackMsg, msg));
            this.monitorRpcMessage(ackMsg, msg);
        }

        public function disconnect():void
        {
            if (!this._disconnectBarrier)
            {
                this._clientIdWaitQueue = null;
                if (this.connected)
                {
                    this._disconnectBarrier = true;
                };
                if (this._channelSetMode == AUTO_CONFIGURED_CHANNELSET)
                {
                    this.internalSetChannelSet(null);
                }
                else
                {
                    if (this._channelSet != null)
                    {
                        this._channelSet.disconnect(this);
                    };
                };
            };
        }

        public function fault(_arg1:ErrorMessage, _arg2:IMessage):void
        {
            if (Log.isError())
            {
                this._log.error("'{0}' {2} fault for '{1}'.", this.id, _arg2.messageId, this._agentType);
            };
            this._ignoreFault = false;
            this.configRequested = false;
            if (_arg1.headers[ErrorMessage.RETRYABLE_HINT_HEADER])
            {
                delete _arg1.headers[ErrorMessage.RETRYABLE_HINT_HEADER];
            };
            if (this.clientId == null)
            {
                if (_arg1.clientId != null)
                {
                    this.setClientId(_arg1.clientId);
                }
                else
                {
                    this.flushClientIdWaitQueue();
                };
            };
            dispatchEvent(MessageFaultEvent.createEvent(_arg1));
            this.monitorRpcMessage(_arg1, _arg2);
            this.handleAuthenticationFault(_arg1, _arg2);
        }

        public function channelConnectHandler(_arg1:ChannelEvent):void
        {
            this._disconnectBarrier = false;
            if (this.needsConfig)
            {
                if (Log.isInfo())
                {
                    this._log.info("'{0}' {1} waiting for configuration information.", this.id, this._agentType);
                };
                this._pendingConnectEvent = _arg1;
            }
            else
            {
                if (Log.isInfo())
                {
                    this._log.info("'{0}' {1} connected.", this.id, this._agentType);
                };
                this.setConnected(true);
                dispatchEvent(_arg1);
            };
        }

        public function channelDisconnectHandler(_arg1:ChannelEvent):void
        {
            if (Log.isWarn())
            {
                this._log.warn("'{0}' {1} channel disconnected.", this.id, this._agentType);
            };
            this.setConnected(false);
            if (this._remoteCredentials != null)
            {
                this._sendRemoteCredentials = true;
            };
            dispatchEvent(_arg1);
        }

        public function channelFaultHandler(_arg1:ChannelFaultEvent):void
        {
            if (Log.isWarn())
            {
                this._log.warn("'{0}' {1} channel faulted with {2} {3}", this.id, this._agentType, _arg1.faultCode, _arg1.faultDetail);
            };
            if (!_arg1.channel.connected)
            {
                this.setConnected(false);
                if (this._remoteCredentials != null)
                {
                    this._sendRemoteCredentials = true;
                };
            };
            dispatchEvent(_arg1);
        }

        public function initialized(_arg1:Object, _arg2:String):void
        {
            this.id = _arg2;
        }

        public function logout():void
        {
            this._credentials = null;
            if (this.channelSet)
            {
                this.channelSet.logout(this);
            };
        }

        public function setCredentials(_arg1:String, _arg2:String, _arg3:String=null):void
        {
            var _local4:String;
            var _local5:Base64Encoder;
            if ((((_arg1 == null)) && ((_arg2 == null))))
            {
                this._credentials = null;
                this._credentialsCharset = null;
            }
            else
            {
                _local4 = ((_arg1 + ":") + _arg2);
                _local5 = new Base64Encoder();
                if (_arg3 == Base64Encoder.CHARSET_UTF_8)
                {
                    _local5.encodeUTFBytes(_local4);
                }
                else
                {
                    _local5.encode(_local4);
                };
                this._credentials = _local5.drain();
                this._credentialsCharset = _arg3;
            };
            if (this.channelSet != null)
            {
                this.channelSet.setCredentials(this._credentials, this, this._credentialsCharset);
            };
        }

        public function setRemoteCredentials(_arg1:String, _arg2:String, _arg3:String=null):void
        {
            var _local4:String;
            var _local5:Base64Encoder;
            if ((((_arg1 == null)) && ((_arg2 == null))))
            {
                this._remoteCredentials = "";
                this._remoteCredentialsCharset = null;
            }
            else
            {
                _local4 = ((_arg1 + ":") + _arg2);
                _local5 = new Base64Encoder();
                if (_arg3 == Base64Encoder.CHARSET_UTF_8)
                {
                    _local5.encodeUTFBytes(_local4);
                }
                else
                {
                    _local5.encode(_local4);
                };
                this._remoteCredentials = _local5.drain();
                this._remoteCredentialsCharset = _arg3;
            };
            this._sendRemoteCredentials = true;
        }

        public function hasPendingRequestForMessage(_arg1:IMessage):Boolean
        {
            return (false);
        }

        mx_internal function internalSetCredentials(_arg1:String):void
        {
            this._credentials = _arg1;
        }

        final protected function assertCredentials(_arg1:String):void
        {
            var _local2:ErrorMessage;
            if (((!((this._credentials == null))) && (!((this._credentials == _arg1)))))
            {
                _local2 = new ErrorMessage();
                _local2.faultCode = "Client.Authentication.Error";
                _local2.faultString = "Credentials specified do not match those used on underlying connection.";
                _local2.faultDetail = "Channel was authenticated with a different set of credentials than those used for this agent.";
                dispatchEvent(MessageFaultEvent.createEvent(_local2));
            };
        }

        final protected function flushClientIdWaitQueue():void
        {
            var _local1:Array;
            if (this._clientIdWaitQueue != null)
            {
                if (this.clientId != null)
                {
                    while (this._clientIdWaitQueue.length > 0)
                    {
                        this.internalSend((this._clientIdWaitQueue.shift() as IMessage));
                    };
                };
                if (this.clientId == null)
                {
                    if (this._clientIdWaitQueue.length > 0)
                    {
                        _local1 = this._clientIdWaitQueue;
                        this._clientIdWaitQueue = null;
                        this.internalSend((_local1.shift() as IMessage));
                        this._clientIdWaitQueue = _local1;
                    }
                    else
                    {
                        this._clientIdWaitQueue = null;
                    };
                };
            };
        }

        protected function handleAuthenticationFault(_arg1:ErrorMessage, _arg2:IMessage):void
        {
            var _local3:Channel;
            if ((((((_arg1.faultCode == "Client.Authentication")) && (this.authenticated))) && (this.isCurrentChannelNotNull())))
            {
                _local3 = this.getCurrentChannel();
                _local3.setAuthenticated(false);
                if ((((_local3 is PollingChannel)) && ((_local3 as PollingChannel).loginAfterDisconnect)))
                {
                    this.reAuthorize(_arg2);
                    this._ignoreFault = true;
                };
            };
        }

        protected function initChannelSet(_arg1:IMessage):void
        {
            if (this._channelSet == null)
            {
                this._channelSetMode = AUTO_CONFIGURED_CHANNELSET;
                this.internalSetChannelSet(ServerConfig.getChannelSet(this.destination));
            };
            if (((((this._channelSet.connected) && (this.needsConfig))) && (!(this.configRequested))))
            {
                _arg1.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
                this.configRequested = true;
            };
            this._channelSet.connect(this);
            if (this._credentials != null)
            {
                this.channelSet.setCredentials(this._credentials, this, this._credentialsCharset);
            };
        }

        protected function internalSend(_arg1:IMessage, _arg2:Boolean=true):void
        {
            var _local3:String;
            if ((((((_arg1.clientId == null)) && (_arg2))) && ((this.clientId == null))))
            {
                if (this._clientIdWaitQueue == null)
                {
                    this._clientIdWaitQueue = [];
                }
                else
                {
                    this._clientIdWaitQueue.push(_arg1);
                    return;
                };
            };
            if (_arg1.clientId == null)
            {
                _arg1.clientId = this.clientId;
            };
            if (this.requestTimeout > 0)
            {
                _arg1.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER] = this.requestTimeout;
            };
            if (this._sendRemoteCredentials)
            {
                if (!(((_arg1 is CommandMessage)) && ((CommandMessage(_arg1).operation == CommandMessage.TRIGGER_CONNECT_OPERATION))))
                {
                    _arg1.headers[AbstractMessage.REMOTE_CREDENTIALS_HEADER] = this._remoteCredentials;
                    _arg1.headers[AbstractMessage.REMOTE_CREDENTIALS_CHARSET_HEADER] = this._remoteCredentialsCharset;
                    this._sendRemoteCredentials = false;
                };
            };
            if (this.channelSet != null)
            {
                if (((!(this.connected)) && ((this._channelSetMode == MANUALLY_ASSIGNED_CHANNELSET))))
                {
                    this._channelSet.connect(this);
                };
                if (((((this.channelSet.connected) && (this.needsConfig))) && (!(this.configRequested))))
                {
                    _arg1.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
                    this.configRequested = true;
                };
                this.channelSet.send(this, _arg1);
                this.monitorRpcMessage(_arg1, _arg1);
            }
            else
            {
                if (((!((this.destination == null))) && ((this.destination.length > 0))))
                {
                    this.initChannelSet(_arg1);
                    if (this.channelSet != null)
                    {
                        this.channelSet.send(this, _arg1);
                        this.monitorRpcMessage(_arg1, _arg1);
                    };
                }
                else
                {
                    _local3 = this.resourceManager.getString("messaging", "destinationNotSet");
                    throw (new InvalidDestinationError(_local3));
                };
            };
        }

        protected function reAuthorize(_arg1:IMessage):void
        {
            if (this.channelSet != null)
            {
                this.channelSet.disconnectAll();
            };
            this.internalSend(_arg1);
        }

        private function getCurrentChannel():Channel
        {
            return ((((this.channelSet)!=null) ? this.channelSet.currentChannel : null));
        }

        private function isCurrentChannelNotNull():Boolean
        {
            return (!((this.getCurrentChannel() == null)));
        }

        private function monitorRpcMessage(_arg1:IMessage, _arg2:IMessage):void
        {
            if (NetworkMonitor.isMonitoring())
            {
                if ((_arg1 is ErrorMessage))
                {
                    NetworkMonitor.monitorFault(_arg2, MessageFaultEvent.createEvent(ErrorMessage(_arg1)));
                }
                else
                {
                    if ((_arg1 is AcknowledgeMessage))
                    {
                        NetworkMonitor.monitorResult(_arg1, MessageEvent.createEvent(MessageEvent.RESULT, _arg2));
                    }
                    else
                    {
                        NetworkMonitor.monitorInvocation(this.getNetmonId(), _arg1, this);
                    };
                };
            };
        }

        mx_internal function getNetmonId():String
        {
            return (null);
        }


    }
}//package mx.messaging
