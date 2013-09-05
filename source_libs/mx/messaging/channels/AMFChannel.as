//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.channels
{
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import mx.core.mx_internal;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.config.ServerConfig;
    import flash.net.Responder;
    import mx.logging.Log;
    import mx.messaging.MessageResponder;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import mx.messaging.events.ChannelFaultEvent;
    import mx.utils.ObjectUtil;
    import flash.events.NetStatusEvent;
    import mx.messaging.messages.AbstractMessage;
    import mx.messaging.FlexClient;
    import mx.messaging.messages.ErrorMessage;
    import mx.messaging.config.ConfigMap;
    import mx.messaging.messages.IMessage;

    use namespace mx_internal;

    public class AMFChannel extends NetConnectionChannel 
    {

        protected var _reconnectingWithSessionId:Boolean;
        private var _ignoreNetStatusEvents:Boolean;
        private var resourceManager:IResourceManager;

        public function AMFChannel(_arg1:String=null, _arg2:String=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super(_arg1, _arg2);
        }

        public function get piggybackingEnabled():Boolean
        {
            return (internalPiggybackingEnabled);
        }

        public function set piggybackingEnabled(_arg1:Boolean):void
        {
            internalPiggybackingEnabled = _arg1;
        }

        public function get pollingEnabled():Boolean
        {
            return (internalPollingEnabled);
        }

        public function set pollingEnabled(_arg1:Boolean):void
        {
            internalPollingEnabled = _arg1;
        }

        public function get pollingInterval():Number
        {
            return (internalPollingInterval);
        }

        public function set pollingInterval(_arg1:Number):void
        {
            internalPollingInterval = _arg1;
        }

        public function get polling():Boolean
        {
            return (pollOutstanding);
        }

        override public function get protocol():String
        {
            return ("http");
        }

        override public function applySettings(_arg1:XML):void
        {
            super.applySettings(_arg1);
            applyPollingSettings(_arg1);
        }

        override public function AppendToGatewayUrl(_arg1:String):void
        {
            if (((((!((_arg1 == null))) && (!((_arg1 == ""))))) && (!((_appendToURL == _arg1)))))
            {
                super.AppendToGatewayUrl(_arg1);
                this._reconnectingWithSessionId = true;
            };
        }

        override protected function internalConnect():void
        {
            super.internalConnect();
            this._ignoreNetStatusEvents = false;
            var _local1:CommandMessage = new CommandMessage();
            if (credentials != null)
            {
                _local1.operation = CommandMessage.LOGIN_OPERATION;
                _local1.body = credentials;
            }
            else
            {
                _local1.operation = CommandMessage.CLIENT_PING_OPERATION;
            };
            _local1.headers[CommandMessage.MESSAGING_VERSION] = messagingVersion;
            if (ServerConfig.needsConfig(this))
            {
                _local1.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
            };
            setFlexClientIdOnMessage(_local1);
            netConnection.call(null, new Responder(this.resultHandler, this.faultHandler), _local1);
            if (Log.isDebug())
            {
                _log.debug("'{0}' pinging endpoint.", id);
            };
        }

        override protected function internalDisconnect(_arg1:Boolean=false):void
        {
            var _local2:CommandMessage;
            if (((!(_arg1)) && (!(shouldBeConnected))))
            {
                _local2 = new CommandMessage();
                _local2.operation = CommandMessage.DISCONNECT_OPERATION;
                this.internalSend(new MessageResponder(null, _local2, null));
            };
            setConnected(false);
            super.internalDisconnect(_arg1);
        }

        override protected function internalSend(_arg1:MessageResponder):void
        {
            this.handleReconnectWithSessionId();
            super.internalSend(_arg1);
        }

        override protected function shutdownNetConnection():void
        {
            _nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            _nc.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            this._ignoreNetStatusEvents = true;
            _nc.close();
        }

        override protected function statusHandler(_arg1:NetStatusEvent):void
        {
            var _local2:ChannelFaultEvent;
            var _local4:Object;
            var _local5:String;
            if (this._ignoreNetStatusEvents)
            {
                return;
            };
            if (Log.isDebug())
            {
                _log.debug("'{0}' channel got status. {1}", id, ObjectUtil.toString(_arg1.info));
            };
            var _local3:Boolean = true;
            if (_arg1.info != null)
            {
                _local4 = _arg1.info;
                if (_local4.level == "error")
                {
                    if (_local4.code == "Client.Data.UnderFlow")
                    {
                        if (Log.isDebug())
                        {
                            _log.debug("'{0}' channel received a 'Client.Data.Underflow' status event.");
                        };
                        return;
                    };
                    if (connected)
                    {
                        if (_local4.code.indexOf("Call.Failed") != -1)
                        {
                            _local2 = ChannelFaultEvent.createEvent(this, false, "Channel.Call.Failed", _local4.level, ((_local4.code + ": ") + _local4.description));
                            _local2.rootCause = _local4;
                            dispatchEvent(_local2);
                        };
                        this.internalDisconnect();
                    }
                    else
                    {
                        _local2 = ChannelFaultEvent.createEvent(this, false, "Channel.Connect.Failed", _local4.level, (((((_local4.code + ": ") + _local4.description) + ": url: '") + endpoint) + "'"));
                        _local2.rootCause = _local4;
                        connectFailed(_local2);
                    };
                }
                else
                {
                    if (!connected)
                    {
                        _local3 = (((_local4.level == "status")) && (!((_local4.code.indexOf("Connect.Closed") == -1))));
                    }
                    else
                    {
                        _local3 = false;
                    };
                };
            }
            else
            {
                _local3 = false;
            };
            if (!_local3)
            {
                _local5 = this.resourceManager.getString("messaging", "invalidURL");
                connectFailed(ChannelFaultEvent.createEvent(this, false, "Channel.Connect.Failed", "error", (((_local5 + " url: '") + endpoint) + "'")));
            };
        }

        protected function handleReconnectWithSessionId():void
        {
            if (this._reconnectingWithSessionId)
            {
                this._reconnectingWithSessionId = false;
                this.shutdownNetConnection();
                super.internalConnect();
                this._ignoreNetStatusEvents = false;
            };
        }

        protected function faultHandler(_arg1:ErrorMessage):void
        {
            var _local2:ChannelFaultEvent;
            var _local3:Number;
            if (_arg1 != null)
            {
                _local2 = null;
                if (_arg1.faultCode == "Client.Authentication")
                {
                    this.resultHandler(_arg1);
                    _local2 = ChannelFaultEvent.createEvent(this, false, "Channel.Authentication.Error", "warn", _arg1.faultString);
                    _local2.rootCause = _arg1;
                    dispatchEvent(_local2);
                }
                else
                {
                    _log.debug("'{0}' fault handler called. {1}", id, _arg1.toString());
                    if ((((FlexClient.getInstance().id == null)) && (!((_arg1.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] == null)))))
                    {
                        FlexClient.getInstance().id = _arg1.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];
                    };
                    if (_arg1.headers[CommandMessage.MESSAGING_VERSION] != null)
                    {
                        _local3 = (_arg1.headers[CommandMessage.MESSAGING_VERSION] as Number);
                        handleServerMessagingVersion(_local3);
                    };
                    _local2 = ChannelFaultEvent.createEvent(this, false, "Channel.Ping.Failed", "error", ((((_arg1.faultString + " url: '") + endpoint) + (((_appendToURL == null)) ? "" : (_appendToURL + "'"))) + "'"));
                    _local2.rootCause = _arg1;
                    connectFailed(_local2);
                };
            };
            this.handleReconnectWithSessionId();
        }

        protected function resultHandler(_arg1:IMessage):void
        {
            var _local2:Number;
            if (_arg1 != null)
            {
                ServerConfig.updateServerConfigData((_arg1.body as ConfigMap), endpoint);
                if ((((FlexClient.getInstance().id == null)) && (!((_arg1.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] == null)))))
                {
                    FlexClient.getInstance().id = _arg1.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];
                };
                if (_arg1.headers[CommandMessage.MESSAGING_VERSION] != null)
                {
                    _local2 = (_arg1.headers[CommandMessage.MESSAGING_VERSION] as Number);
                    handleServerMessagingVersion(_local2);
                };
            };
            this.handleReconnectWithSessionId();
            connectSuccess();
            if (((!((credentials == null))) && (!((_arg1 is ErrorMessage)))))
            {
                setAuthenticated(true);
            };
        }


    }
}//package mx.messaging.channels
