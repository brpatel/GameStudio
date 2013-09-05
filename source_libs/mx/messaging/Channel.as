//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import flash.events.EventDispatcher;
    import mx.collections.ArrayCollection;
    import mx.core.mx_internal;
    import mx.logging.ILogger;
    import flash.utils.Timer;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.logging.Log;
    import mx.events.PropertyChangeEvent;
    import flash.errors.IllegalOperationError;
    import mx.messaging.events.ChannelEvent;
    import mx.messaging.events.ChannelFaultEvent;
    import flash.events.TimerEvent;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.errors.InvalidDestinationError;
    import mx.messaging.messages.AbstractMessage;
    import mx.messaging.messages.IMessage;
    import mx.messaging.config.ServerConfig;
    import mx.messaging.errors.InvalidChannelError;
    import mx.utils.URLUtil;
    import mx.messaging.config.LoaderConfig;
    import flash.utils.getDefinitionByName;
    import mx.rpc.AsyncDispatcher;
    import mx.core.*;

    use namespace mx_internal;

    public class Channel extends EventDispatcher implements IMXMLObject 
    {

        protected static const CLIENT_LOAD_BALANCING:String = "client-load-balancing";
        protected static const CONNECT_TIMEOUT_SECONDS:String = "connect-timeout-seconds";
        protected static const ENABLE_SMALL_MESSAGES:String = "enable-small-messages";
        protected static const FALSE:String = "false";
        protected static const RECORD_MESSAGE_TIMES:String = "record-message-times";
        protected static const RECORD_MESSAGE_SIZES:String = "record-message-sizes";
        protected static const REQUEST_TIMEOUT_SECONDS:String = "request-timeout-seconds";
        protected static const SERIALIZATION:String = "serialization";
        protected static const TRUE:String = "true";
        public static const SMALL_MESSAGES_FEATURE:String = "small_messages";
        private static const dep:ArrayCollection = null;

        mx_internal var authenticating:Boolean;
        protected var credentials:String;
        public var enableSmallMessages:Boolean = true;
        protected var _log:ILogger;
        protected var _connecting:Boolean;
        private var _connectTimer:Timer;
        private var _failoverIndex:int;
        private var _isEndpointCalculated:Boolean;
        protected var messagingVersion:Number = 1;
        private var _ownsWaitGuard:Boolean;
        private var _previouslyConnected:Boolean;
        private var _primaryURI:String;
        mx_internal var reliableReconnectDuration:int = -1;
        private var _reliableReconnectBeginTimestamp:Number;
        private var _reliableReconnectLastTimestamp:Number;
        private var _reliableReconnectAttempts:int;
        private var resourceManager:IResourceManager;
        private var _channelSets:Array;
        private var _connected:Boolean = false;
        private var _connectTimeout:int = -1;
        private var _endpoint:String;
        protected var _recordMessageTimes:Boolean = false;
        protected var _recordMessageSizes:Boolean = false;
        private var _reconnecting:Boolean = false;
        private var _failoverURIs:Array;
        private var _id:String;
        private var _authenticated:Boolean = false;
        private var _requestTimeout:int = -1;
        private var _shouldBeConnected:Boolean;
        private var _uri:String;
        private var _smallMessagesSupported:Boolean;

        public function Channel(_arg1:String=null, _arg2:String=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            this._channelSets = [];
            super();
            this._log = Log.getLogger("mx.messaging.Channel");
            this._failoverIndex = -1;
            this.id = _arg1;
            this._primaryURI = _arg2;
            this.uri = _arg2;
        }

        public function initialized(_arg1:Object, _arg2:String):void
        {
            this.id = _arg2;
        }

        public function get channelSets():Array
        {
            return (this._channelSets);
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
                if (this._connected)
                {
                    this._previouslyConnected = true;
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "connected", this._connected, _arg1);
                this._connected = _arg1;
                dispatchEvent(_local2);
                if (!_arg1)
                {
                    this.setAuthenticated(false);
                };
            };
        }

        public function get connectTimeout():int
        {
            return (this._connectTimeout);
        }

        public function set connectTimeout(_arg1:int):void
        {
            this._connectTimeout = _arg1;
        }

        public function get endpoint():String
        {
            if (!this._isEndpointCalculated)
            {
                this.calculateEndpoint();
            };
            return (this._endpoint);
        }

        public function get recordMessageTimes():Boolean
        {
            return (this._recordMessageTimes);
        }

        public function get recordMessageSizes():Boolean
        {
            return (this._recordMessageSizes);
        }

        [Bindable(event="propertyChange")]
        public function get reconnecting():Boolean
        {
            return (this._reconnecting);
        }

        private function setReconnecting(_arg1:Boolean):void
        {
            var _local2:PropertyChangeEvent;
            if (this._reconnecting != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "reconnecting", this._reconnecting, _arg1);
                this._reconnecting = _arg1;
                dispatchEvent(_local2);
            };
        }

        public function get failoverURIs():Array
        {
            return ((((this._failoverURIs)!=null) ? this._failoverURIs : []));
        }

        public function set failoverURIs(_arg1:Array):void
        {
            if (_arg1 != null)
            {
                this._failoverURIs = _arg1;
                this._failoverIndex = -1;
            };
        }

        public function get id():String
        {
            return (this._id);
        }

        public function set id(_arg1:String):void
        {
            if (this._id != _arg1)
            {
                this._id = _arg1;
            };
        }

        [Bindable(event="propertyChange")]
        public function get authenticated():Boolean
        {
            return (this._authenticated);
        }

        mx_internal function setAuthenticated(_arg1:Boolean):void
        {
            var _local2:PropertyChangeEvent;
            var _local3:ChannelSet;
            var _local4:int;
            if (_arg1 != this._authenticated)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "authenticated", this._authenticated, _arg1);
                this._authenticated = _arg1;
                _local4 = 0;
                while (_local4 < this._channelSets.length)
                {
                    _local3 = ChannelSet(this._channelSets[_local4]);
                    _local3.setAuthenticated(this.authenticated, this.credentials);
                    _local4++;
                };
                dispatchEvent(_local2);
            };
        }

        public function get protocol():String
        {
            throw (new IllegalOperationError((("Channel subclasses must override " + "the get function for 'protocol' to return the proper protocol ") + "string.")));
        }

        mx_internal function get realtime():Boolean
        {
            return (false);
        }

        public function get requestTimeout():int
        {
            return (this._requestTimeout);
        }

        public function set requestTimeout(_arg1:int):void
        {
            this._requestTimeout = _arg1;
        }

        protected function get shouldBeConnected():Boolean
        {
            return (this._shouldBeConnected);
        }

        public function get uri():String
        {
            return (this._uri);
        }

        public function set uri(_arg1:String):void
        {
            if (_arg1 != null)
            {
                this._uri = _arg1;
                this.calculateEndpoint();
            };
        }

        public function get url():String
        {
            return (this.uri);
        }

        public function set url(_arg1:String):void
        {
            this.uri = _arg1;
        }

        public function get useSmallMessages():Boolean
        {
            return (((this._smallMessagesSupported) && (this.enableSmallMessages)));
        }

        public function set useSmallMessages(_arg1:Boolean):void
        {
            this._smallMessagesSupported = _arg1;
        }

        public function applySettings(_arg1:XML):void
        {
            if (Log.isInfo())
            {
                this._log.info("'{0}' channel settings are:\n{1}", this.id, _arg1);
            };
            if (_arg1.properties.length() == 0)
            {
                return;
            };
            var _local2:XML = _arg1.properties[0];
            this.applyClientLoadBalancingSettings(_local2);
            if (_local2[CONNECT_TIMEOUT_SECONDS].length() != 0)
            {
                this.connectTimeout = _local2[CONNECT_TIMEOUT_SECONDS].toString();
            };
            if (_local2[RECORD_MESSAGE_TIMES].length() != 0)
            {
                this._recordMessageTimes = (_local2[RECORD_MESSAGE_TIMES].toString() == TRUE);
            };
            if (_local2[RECORD_MESSAGE_SIZES].length() != 0)
            {
                this._recordMessageSizes = (_local2[RECORD_MESSAGE_SIZES].toString() == TRUE);
            };
            if (_local2[REQUEST_TIMEOUT_SECONDS].length() != 0)
            {
                this.requestTimeout = _local2[REQUEST_TIMEOUT_SECONDS].toString();
            };
            var _local3:XMLList = _local2[SERIALIZATION];
            if (((!((_local3.length() == 0))) && ((_local3[ENABLE_SMALL_MESSAGES].toString() == FALSE))))
            {
                this.enableSmallMessages = false;
            };
        }

        protected function applyClientLoadBalancingSettings(_arg1:XML):void
        {
            var _local5:XML;
            var _local2:XMLList = _arg1[CLIENT_LOAD_BALANCING];
            if (_local2.length() == 0)
            {
                return;
            };
            var _local3:int = _local2.url.length();
            if (_local3 == 0)
            {
                return;
            };
            var _local4:Array = new Array();
            for each (_local5 in _local2.url)
            {
                _local4.push(_local5.toString());
            };
            this.shuffle(_local4);
            if (Log.isInfo())
            {
                this._log.info("'{0}' channel picked {1} as its main url.", this.id, _local4[0]);
            };
            this.url = _local4[0];
            var _local6:Array = _local4.slice(1);
            if (_local6.length > 0)
            {
                this.failoverURIs = _local6;
            };
        }

        final public function connect(_arg1:ChannelSet):void
        {
            var _local5:FlexClient;
            var _local2:Boolean;
            var _local3:int = this._channelSets.length;
            var _local4:int;
            while (_local4 < this._channelSets.length)
            {
                if (this._channelSets[_local4] == _arg1)
                {
                    _local2 = true;
                    break;
                };
                _local4++;
            };
            this._shouldBeConnected = true;
            if (!_local2)
            {
                this._channelSets.push(_arg1);
                addEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler);
                addEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler);
                addEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler);
            };
            if (this.connected)
            {
                _arg1.channelConnectHandler(ChannelEvent.createEvent(ChannelEvent.CONNECT, this, false, false, this.connected));
            }
            else
            {
                if (!this._connecting)
                {
                    this._connecting = true;
                    if (this.connectTimeout > 0)
                    {
                        this._connectTimer = new Timer((this.connectTimeout * 1000), 1);
                        this._connectTimer.addEventListener(TimerEvent.TIMER, this.connectTimeoutHandler);
                        this._connectTimer.start();
                    };
                    if (FlexClient.getInstance().id == null)
                    {
                        _local5 = FlexClient.getInstance();
                        if (!_local5.waitForFlexClientId)
                        {
                            _local5.waitForFlexClientId = true;
                            this._ownsWaitGuard = true;
                            this.internalConnect();
                        }
                        else
                        {
                            _local5.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.flexClientWaitHandler);
                        };
                    }
                    else
                    {
                        this.internalConnect();
                    };
                };
            };
        }

        final public function disconnect(_arg1:ChannelSet):void
        {
            if (this._ownsWaitGuard)
            {
                this._ownsWaitGuard = false;
                FlexClient.getInstance().waitForFlexClientId = false;
            };
            var _local2:int = (((_arg1)!=null) ? this._channelSets.indexOf(_arg1) : -1);
            if (_local2 != -1)
            {
                this._channelSets.splice(_local2, 1);
                removeEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler, false);
                removeEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler, false);
                removeEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler, false);
                if (this.connected)
                {
                    _arg1.channelDisconnectHandler(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, this, false));
                };
                if (this._channelSets.length == 0)
                {
                    this._shouldBeConnected = false;
                    if (this.connected)
                    {
                        this.internalDisconnect();
                    };
                };
            };
        }

        public function logout(_arg1:MessageAgent):void
        {
            var _local2:CommandMessage;
            if (((((((this.connected) && (this.authenticated))) && (this.credentials))) || (((this.authenticating) && (this.credentials)))))
            {
                _local2 = new CommandMessage();
                _local2.operation = CommandMessage.LOGOUT_OPERATION;
                this.internalSend(new AuthenticationMessageResponder(_arg1, _local2, this, this._log));
                this.authenticating = true;
            };
            this.credentials = null;
        }

        public function send(_arg1:MessageAgent, _arg2:IMessage):void
        {
            var _local4:String;
            if (_arg2.destination.length == 0)
            {
                if (_arg1.destination.length == 0)
                {
                    _local4 = this.resourceManager.getString("messaging", "noDestinationSpecified");
                    throw (new InvalidDestinationError(_local4));
                };
                _arg2.destination = _arg1.destination;
            };
            if (Log.isDebug())
            {
                this._log.debug("'{0}' channel sending message:\n{1}", this.id, _arg2.toString());
            };
            _arg2.headers[AbstractMessage.ENDPOINT_HEADER] = this.id;
            var _local3:MessageResponder = this.getMessageResponder(_arg1, _arg2);
            this.initializeRequestTimeout(_local3);
            this.internalSend(_local3);
        }

        public function setCredentials(_arg1:String, _arg2:MessageAgent=null, _arg3:String=null):void
        {
            var _local5:CommandMessage;
            var _local4 = !((this.credentials === _arg1));
            if (((this.authenticating) && (_local4)))
            {
                throw (new IllegalOperationError("Credentials cannot be set while authenticating or logging out."));
            };
            if (((this.authenticated) && (_local4)))
            {
                throw (new IllegalOperationError("Credentials cannot be set when already authenticated. Logout must be performed before changing credentials."));
            };
            this.credentials = _arg1;
            if (((((this.connected) && (_local4))) && (!((_arg1 == null)))))
            {
                this.authenticating = true;
                _local5 = new CommandMessage();
                _local5.operation = CommandMessage.LOGIN_OPERATION;
                _local5.body = _arg1;
                if (_arg3 != null)
                {
                    _local5.headers[CommandMessage.CREDENTIALS_CHARSET_HEADER] = _arg3;
                };
                this.internalSend(new AuthenticationMessageResponder(_arg2, _local5, this, this._log));
            };
        }

        public function get mpiEnabled():Boolean
        {
            return (((this._recordMessageSizes) || (this._recordMessageTimes)));
        }

        mx_internal function internalSetCredentials(_arg1:String):void
        {
            this.credentials = _arg1;
        }

        mx_internal function sendInternalMessage(_arg1:MessageResponder):void
        {
            this.internalSend(_arg1);
        }

        protected function connectFailed(_arg1:ChannelFaultEvent):void
        {
            this.shutdownConnectTimer();
            this.setConnected(false);
            if (Log.isError())
            {
                this._log.error("'{0}' channel connect failed.", this.id);
            };
            if (((!(_arg1.rejected)) && (this.shouldAttemptFailover())))
            {
                this._connecting = true;
                this.failover();
            }
            else
            {
                this.connectCleanup();
            };
            if (this.reconnecting)
            {
                _arg1.reconnecting = true;
            };
            dispatchEvent(_arg1);
        }

        protected function connectSuccess():void
        {
            var _local1:int;
            var _local2:Array;
            var _local3:int;
            this.shutdownConnectTimer();
            if (ServerConfig.fetchedConfig(this.endpoint))
            {
                _local1 = 0;
                while (_local1 < this.channelSets.length)
                {
                    _local2 = ChannelSet(this.channelSets[_local1]).messageAgents;
                    _local3 = 0;
                    while (_local3 < _local2.length)
                    {
                        _local2[_local3].needsConfig = false;
                        _local3++;
                    };
                    _local1++;
                };
            };
            this.setConnected(true);
            this._failoverIndex = -1;
            if (Log.isInfo())
            {
                this._log.info("'{0}' channel is connected.", this.id);
            };
            dispatchEvent(ChannelEvent.createEvent(ChannelEvent.CONNECT, this, this.reconnecting));
            this.connectCleanup();
        }

        protected function connectTimeoutHandler(_arg1:TimerEvent):void
        {
            var _local2:String;
            var _local3:ChannelFaultEvent;
            this.shutdownConnectTimer();
            if (!this.connected)
            {
                this._shouldBeConnected = false;
                _local2 = this.resourceManager.getString("messaging", "connectTimedOut");
                _local3 = ChannelFaultEvent.createEvent(this, false, "Channel.Connect.Failed", "error", _local2);
                this.connectFailed(_local3);
            };
        }

        protected function disconnectSuccess(_arg1:Boolean=false):void
        {
            this.setConnected(false);
            if (Log.isInfo())
            {
                this._log.info("'{0}' channel disconnected.", this.id);
            };
            if (((!(_arg1)) && (this.shouldAttemptFailover())))
            {
                this._connecting = true;
                this.failover();
            }
            else
            {
                this.connectCleanup();
            };
            dispatchEvent(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, this, this.reconnecting, _arg1));
        }

        protected function disconnectFailed(_arg1:ChannelFaultEvent):void
        {
            this._connecting = false;
            this.setConnected(false);
            if (Log.isError())
            {
                this._log.error("'{0}' channel disconnect failed.", this.id);
            };
            if (this.reconnecting)
            {
                this.resetToPrimaryURI();
                _arg1.reconnecting = false;
            };
            dispatchEvent(_arg1);
        }

        protected function flexClientWaitHandler(_arg1:PropertyChangeEvent):void
        {
            var _local2:FlexClient;
            if (_arg1.property == "waitForFlexClientId")
            {
                _local2 = (_arg1.source as FlexClient);
                if (_local2.waitForFlexClientId == false)
                {
                    _local2.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.flexClientWaitHandler);
                    _local2.waitForFlexClientId = true;
                    this._ownsWaitGuard = true;
                    this.internalConnect();
                };
            };
        }

        protected function getMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder
        {
            throw (new IllegalOperationError(("Channel subclasses must override " + " getMessageResponder().")));
        }

        protected function internalConnect():void
        {
        }

        protected function internalDisconnect(_arg1:Boolean=false):void
        {
        }

        protected function internalSend(_arg1:MessageResponder):void
        {
        }

        protected function handleServerMessagingVersion(_arg1:Number):void
        {
            this.useSmallMessages = (_arg1 >= this.messagingVersion);
        }

        protected function setFlexClientIdOnMessage(_arg1:IMessage):void
        {
            var _local2:String = FlexClient.getInstance().id;
            _arg1.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] = (((_local2)!=null) ? _local2 : FlexClient.NULL_FLEXCLIENT_ID);
        }

        private function calculateEndpoint():void
        {
            var _local3:String;
            if (this.uri == null)
            {
                _local3 = this.resourceManager.getString("messaging", "noURLSpecified");
                throw (new InvalidChannelError(_local3));
            };
            var _local1:String = this.uri;
            var _local2:String = URLUtil.getProtocol(_local1);
            if (_local2.length == 0)
            {
                _local1 = URLUtil.getFullURL(LoaderConfig.url, _local1);
            };
            if (((URLUtil.hasTokens(_local1)) && (!(URLUtil.hasUnresolvableTokens()))))
            {
                this._isEndpointCalculated = false;
                return;
            };
            _local1 = URLUtil.replaceTokens(_local1);
            _local2 = URLUtil.getProtocol(_local1);
            if (_local2.length > 0)
            {
                this._endpoint = URLUtil.replaceProtocol(_local1, this.protocol);
            }
            else
            {
                this._endpoint = ((this.protocol + ":") + _local1);
            };
            this._isEndpointCalculated = true;
            if (Log.isInfo())
            {
                this._log.info("'{0}' channel endpoint set to {1}", this.id, this._endpoint);
            };
        }

        private function initializeRequestTimeout(_arg1:MessageResponder):void
        {
            var _local2:IMessage = _arg1.message;
            if (_local2.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER] != null)
            {
                _arg1.startRequestTimeout(_local2.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER]);
            }
            else
            {
                if (this.requestTimeout > 0)
                {
                    _arg1.startRequestTimeout(this.requestTimeout);
                };
            };
        }

        private function shouldAttemptFailover():Boolean
        {
            return (((this._shouldBeConnected) && (((((this._previouslyConnected) || (!((this.reliableReconnectDuration == -1))))) || (((!((this._failoverURIs == null))) && ((this._failoverURIs.length > 0))))))));
        }

        private function failover():void
        {
            var _local1:Class;
            var _local2:int;
            var _local3:ChannelSet;
            var _local4:int;
            var _local5:Number;
            var _local6:int;
            if (this._previouslyConnected)
            {
                this._previouslyConnected = false;
                _local1 = null;
                try
                {
                    _local1 = (getDefinitionByName("mx.messaging.AdvancedChannelSet") as Class);
                }
                catch(ignore:Error)
                {
                };
                _local2 = -1;
                if (_local1 != null)
                {
                    for each (_local3 in this.channelSets)
                    {
                        if ((_local3 is _local1))
                        {
                            _local4 = (_local3 as _local1)["reliableReconnectDuration"];
                            if (_local4 > _local2)
                            {
                                _local2 = _local4;
                            };
                        };
                    };
                };
                if (_local2 != -1)
                {
                    this.setReconnecting(true);
                    this.reliableReconnectDuration = _local2;
                    this._reliableReconnectBeginTimestamp = new Date().valueOf();
                    new AsyncDispatcher(this.reconnect, null, 1);
                    return;
                };
            };
            if (this.reliableReconnectDuration != -1)
            {
                this._reliableReconnectLastTimestamp = new Date().valueOf();
                _local5 = (this.reliableReconnectDuration - (this._reliableReconnectLastTimestamp - this._reliableReconnectBeginTimestamp));
                if (_local5 > 0)
                {
                    _local6 = 1000;
                    (_local6 << ++this._reliableReconnectAttempts);
                    if (_local6 < _local5)
                    {
                        new AsyncDispatcher(this.reconnect, null, _local6);
                        return;
                    };
                };
                this.reliableReconnectCleanup();
            };
            this._failoverIndex++;
            if ((this._failoverIndex + 1) <= this.failoverURIs.length)
            {
                this.setReconnecting(true);
                this.uri = this.failoverURIs[this._failoverIndex];
                if (Log.isInfo())
                {
                    this._log.info("'{0}' channel attempting to connect to {1}.", this.id, this.endpoint);
                };
                new AsyncDispatcher(this.reconnect, null, 1);
            }
            else
            {
                if (Log.isInfo())
                {
                    this._log.info("'{0}' channel has exhausted failover options and has reset to its primary endpoint.", this.id);
                };
                this.resetToPrimaryURI();
            };
        }

        private function connectCleanup():void
        {
            if (this._ownsWaitGuard)
            {
                this._ownsWaitGuard = false;
                FlexClient.getInstance().waitForFlexClientId = false;
            };
            this._connecting = false;
            this.setReconnecting(false);
            this.reliableReconnectCleanup();
        }

        private function reconnect(_arg1:TimerEvent=null):void
        {
            this.internalConnect();
        }

        private function reliableReconnectCleanup():void
        {
            this.reliableReconnectDuration = -1;
            this._reliableReconnectBeginTimestamp = 0;
            this._reliableReconnectLastTimestamp = 0;
            this._reliableReconnectAttempts = 0;
        }

        private function resetToPrimaryURI():void
        {
            this._connecting = false;
            this.setReconnecting(false);
            this.uri = this._primaryURI;
            this._failoverIndex = -1;
        }

        private function shuffle(_arg1:Array):void
        {
            var _local4:int;
            var _local5:Object;
            var _local2:int = _arg1.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                _local4 = Math.floor((Math.random() * _local2));
                if (_local4 != _local3)
                {
                    _local5 = _arg1[_local3];
                    _arg1[_local3] = _arg1[_local4];
                    _arg1[_local4] = _local5;
                };
                _local3++;
            };
        }

        private function shutdownConnectTimer():void
        {
            if (this._connectTimer != null)
            {
                this._connectTimer.stop();
                this._connectTimer.removeEventListener(TimerEvent.TIMER, this.connectTimeoutHandler);
                this._connectTimer = null;
            };
        }


    }
}//package mx.messaging

import mx.messaging.MessageResponder;
import mx.logging.ILogger;
import mx.messaging.MessageAgent;
import mx.messaging.messages.IMessage;
import mx.messaging.Channel;
import mx.messaging.messages.CommandMessage;
import mx.core.mx_internal;
import mx.logging.Log;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.events.ChannelFaultEvent;

use namespace mx_internal;

class AuthenticationMessageResponder extends MessageResponder 
{

    private var _log:ILogger;

    public function AuthenticationMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:Channel, _arg4:ILogger)
    {
        super(_arg1, _arg2, _arg3);
        this._log = _arg4;
    }

    override protected function resultHandler(_arg1:IMessage):void
    {
        var _local2:CommandMessage = (message as CommandMessage);
        channel.authenticating = false;
        if (_local2.operation == CommandMessage.LOGIN_OPERATION)
        {
            if (Log.isDebug())
            {
                this._log.debug("Login successful");
            };
            channel.setAuthenticated(true);
        }
        else
        {
            if (Log.isDebug())
            {
                this._log.debug("Logout successful");
            };
            channel.setAuthenticated(false);
        };
    }

    override protected function statusHandler(_arg1:IMessage):void
    {
        var _local3:ErrorMessage;
        var _local4:ChannelFaultEvent;
        var _local2:CommandMessage = CommandMessage(message);
        if (Log.isDebug())
        {
            this._log.debug("{1} failure: {0}", _arg1.toString(), (((_local2.operation == CommandMessage.LOGIN_OPERATION)) ? "Login" : "Logout"));
        };
        channel.authenticating = false;
        channel.setAuthenticated(false);
        if (((!((agent == null))) && (agent.hasPendingRequestForMessage(message))))
        {
            agent.fault(ErrorMessage(_arg1), message);
        }
        else
        {
            _local3 = ErrorMessage(_arg1);
            _local4 = ChannelFaultEvent.createEvent(channel, false, "Channel.Authentication.Error", "warn", _local3.faultString);
            _local4.rootCause = _local3;
            channel.dispatchEvent(_local4);
        };
    }


}
