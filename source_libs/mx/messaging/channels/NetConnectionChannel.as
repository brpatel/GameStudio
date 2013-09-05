//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.channels
{
    import mx.core.mx_internal;
    import flash.net.NetConnection;
    import flash.net.ObjectEncoding;
    import flash.events.TimerEvent;
    import mx.messaging.MessageAgent;
    import mx.messaging.messages.IMessage;
    import mx.messaging.MessageResponder;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.AsyncErrorEvent;
    import mx.netmon.NetworkMonitor;
    import mx.messaging.config.LoaderConfig;
    import mx.messaging.messages.MessagePerformanceInfo;
    import mx.messaging.messages.MessagePerformanceUtils;
    import mx.messaging.messages.ISmallMessage;
    import mx.logging.Log;
    import mx.messaging.events.MessageEvent;
    import mx.messaging.events.ChannelFaultEvent;
    import flash.events.ErrorEvent;

    use namespace mx_internal;

    public class NetConnectionChannel extends PollingChannel 
    {

        mx_internal var _appendToURL:String;
        protected var _nc:NetConnection;

        public function NetConnectionChannel(_arg1:String=null, _arg2:String=null)
        {
            super(_arg1, _arg2);
            this._nc = new NetConnection();
            this._nc.objectEncoding = ObjectEncoding.AMF3;
            this._nc.client = this;
        }

        public function get netConnection():NetConnection
        {
            return (this._nc);
        }

        override public function get useSmallMessages():Boolean
        {
            return (((((super.useSmallMessages) && (!((this._nc == null))))) && ((this._nc.objectEncoding >= ObjectEncoding.AMF3))));
        }

        override protected function connectTimeoutHandler(_arg1:TimerEvent):void
        {
            this.shutdownNetConnection();
            super.connectTimeoutHandler(_arg1);
        }

        override protected function getDefaultMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder
        {
            return (new NetConnectionMessageResponder(_arg1, _arg2, this));
        }

        override protected function internalDisconnect(_arg1:Boolean=false):void
        {
            super.internalDisconnect(_arg1);
            this.shutdownNetConnection();
            disconnectSuccess(_arg1);
        }

        override protected function internalConnect():void
        {
            var url:String;
            var i:int;
            var temp:String;
            var j:int;
            var redirectedUrl:String;
            super.internalConnect();
            url = endpoint;
            if (this._appendToURL != null)
            {
                i = url.indexOf("wsrp-url=");
                if (i != -1)
                {
                    temp = url.substr((i + 9), url.length);
                    j = temp.indexOf("&");
                    if (j != -1)
                    {
                        temp = temp.substr(0, j);
                    };
                    url = url.replace(temp, (temp + this._appendToURL));
                }
                else
                {
                    url = (url + this._appendToURL);
                };
            };
            if (((((!((this._nc.uri == null))) && ((this._nc.uri.length > 0)))) && (this._nc.connected)))
            {
                this._nc.removeEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
                this._nc.close();
            };
            if (((("httpIdleTimeout" in this._nc)) && ((requestTimeout > 0))))
            {
                this._nc["httpIdleTimeout"] = (requestTimeout * 1000);
            };
            this._nc.addEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
            this._nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._nc.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            try
            {
                if (NetworkMonitor.isMonitoring())
                {
                    redirectedUrl = NetworkMonitor.adjustNetConnectionURL(LoaderConfig.url, url);
                    if (redirectedUrl != null)
                    {
                        url = redirectedUrl;
                    };
                };
                this._nc.connect(url);
            }
            catch(e:Error)
            {
                e.message = (e.message + (("  url: '" + url) + "'"));
                throw (e);
            };
        }

        override protected function internalSend(_arg1:MessageResponder):void
        {
            var _local3:MessagePerformanceInfo;
            var _local4:IMessage;
            setFlexClientIdOnMessage(_arg1.message);
            if (mpiEnabled)
            {
                _local3 = new MessagePerformanceInfo();
                if (recordMessageTimes)
                {
                    _local3.sendTime = new Date().getTime();
                };
                _arg1.message.headers[MessagePerformanceUtils.MPI_HEADER_IN] = _local3;
            };
            var _local2:IMessage = _arg1.message;
            if (((this.useSmallMessages) && ((_local2 is ISmallMessage))))
            {
                _local4 = ISmallMessage(_local2).getSmallMessage();
                if (_local4 != null)
                {
                    _local2 = _local4;
                };
            };
            this._nc.call(null, _arg1, _local2);
        }

        public function AppendToGatewayUrl(_arg1:String):void
        {
            if (((((!((_arg1 == null))) && (!((_arg1 == ""))))) && (!((_arg1 == this._appendToURL)))))
            {
                if (Log.isDebug())
                {
                    _log.debug("'{0}' channel will disconnect and reconnect with with its session identifier '{1}' appended to its endpoint url \n", id, _arg1);
                };
                this._appendToURL = _arg1;
            };
        }

        public function receive(_arg1:IMessage, ... _args):void
        {
            var mpiutil:MessagePerformanceUtils;
            var msg:IMessage = _arg1;
            var rest:Array = _args;
            if (Log.isDebug())
            {
                _log.debug("'{0}' channel got message\n{1}\n", id, msg.toString());
                if (this.mpiEnabled)
                {
                    try
                    {
                        mpiutil = new MessagePerformanceUtils(msg);
                        _log.debug(mpiutil.prettyPrint());
                    }
                    catch(e:Error)
                    {
                        _log.debug(("Could not get message performance information for: " + msg.toString()));
                    };
                };
            };
            dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE, msg));
        }

        protected function shutdownNetConnection():void
        {
            this._nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._nc.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._nc.removeEventListener(NetStatusEvent.NET_STATUS, this.statusHandler);
            this._nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._nc.close();
        }

        protected function statusHandler(_arg1:NetStatusEvent):void
        {
        }

        protected function securityErrorHandler(_arg1:SecurityErrorEvent):void
        {
            this.defaultErrorHandler("Channel.Security.Error", _arg1);
        }

        protected function ioErrorHandler(_arg1:IOErrorEvent):void
        {
            this.defaultErrorHandler("Channel.IO.Error", _arg1);
        }

        protected function asyncErrorHandler(_arg1:AsyncErrorEvent):void
        {
            this.defaultErrorHandler("Channel.Async.Error", _arg1);
        }

        private function defaultErrorHandler(_arg1:String, _arg2:ErrorEvent):void
        {
            var _local3:ChannelFaultEvent = ChannelFaultEvent.createEvent(this, false, _arg1, "error", (((_arg2.text + " url: '") + endpoint) + "'"));
            _local3.rootCause = _arg2;
            if (_connecting)
            {
                connectFailed(_local3);
            }
            else
            {
                dispatchEvent(_local3);
            };
        }


    }
}//package mx.messaging.channels

import mx.messaging.MessageResponder;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.messaging.events.ChannelEvent;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.MessageAgent;
import mx.messaging.messages.IMessage;
import mx.messaging.channels.NetConnectionChannel;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.AsyncMessage;
import mx.messaging.messages.AcknowledgeMessage;

class NetConnectionMessageResponder extends MessageResponder 
{

    private var handled:Boolean;
    private var resourceManager:IResourceManager;

    public function NetConnectionMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:NetConnectionChannel)
    {
        this.resourceManager = ResourceManager.getInstance();
        super(_arg1, _arg2, _arg3);
        _arg3.addEventListener(ChannelEvent.DISCONNECT, this.channelDisconnectHandler);
        _arg3.addEventListener(ChannelFaultEvent.FAULT, this.channelFaultHandler);
    }

    override protected function resultHandler(_arg1:IMessage):void
    {
        var _local2:ErrorMessage;
        if (this.handled)
        {
            return;
        };
        this.disconnect();
        if ((_arg1 is AsyncMessage))
        {
            if (AsyncMessage(_arg1).correlationId == message.messageId)
            {
                agent.acknowledge((_arg1 as AcknowledgeMessage), message);
            }
            else
            {
                _local2 = new ErrorMessage();
                _local2.faultCode = "Server.Acknowledge.Failed";
                _local2.faultString = this.resourceManager.getString("messaging", "ackFailed");
                _local2.faultDetail = this.resourceManager.getString("messaging", "ackFailed.details", [message.messageId, AsyncMessage(_arg1).correlationId]);
                _local2.correlationId = message.messageId;
                agent.fault(_local2, message);
            };
        }
        else
        {
            _local2 = new ErrorMessage();
            _local2.faultCode = "Server.Acknowledge.Failed";
            _local2.faultString = this.resourceManager.getString("messaging", "noAckMessage");
            _local2.faultDetail = this.resourceManager.getString("messaging", "noAckMessage.details", [((_arg1) ? _arg1.toString() : "null")]);
            _local2.correlationId = message.messageId;
            agent.fault(_local2, message);
        };
    }

    override protected function statusHandler(_arg1:IMessage):void
    {
        var _local2:AcknowledgeMessage;
        var _local3:ErrorMessage;
        if (this.handled)
        {
            return;
        };
        this.disconnect();
        if ((_arg1 is AsyncMessage))
        {
            if (AsyncMessage(_arg1).correlationId == message.messageId)
            {
                _local2 = new AcknowledgeMessage();
                _local2.correlationId = AsyncMessage(_arg1).correlationId;
                _local2.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
                agent.acknowledge(_local2, message);
                agent.fault((_arg1 as ErrorMessage), message);
            }
            else
            {
                if ((_arg1 is ErrorMessage))
                {
                    agent.fault((_arg1 as ErrorMessage), message);
                }
                else
                {
                    _local3 = new ErrorMessage();
                    _local3.faultCode = "Server.Acknowledge.Failed";
                    _local3.faultString = this.resourceManager.getString("messaging", "noErrorForMessage");
                    _local3.faultDetail = this.resourceManager.getString("messaging", "noErrorForMessage.details", [message.messageId, AsyncMessage(_arg1).correlationId]);
                    _local3.correlationId = message.messageId;
                    agent.fault(_local3, message);
                };
            };
        }
        else
        {
            _local3 = new ErrorMessage();
            _local3.faultCode = "Server.Acknowledge.Failed";
            _local3.faultString = this.resourceManager.getString("messaging", "noAckMessage");
            _local3.faultDetail = this.resourceManager.getString("messaging", "noAckMessage.details", [((_arg1) ? _arg1.toString() : "null")]);
            _local3.correlationId = message.messageId;
            agent.fault(_local3, message);
        };
    }

    override protected function requestTimedOut():void
    {
        this.statusHandler(createRequestTimeoutErrorMessage());
    }

    protected function channelDisconnectHandler(_arg1:ChannelEvent):void
    {
        if (this.handled)
        {
            return;
        };
        this.disconnect();
        var _local2:ErrorMessage = new ErrorMessage();
        _local2.correlationId = message.messageId;
        _local2.faultString = this.resourceManager.getString("messaging", "deliveryInDoubt");
        _local2.faultDetail = this.resourceManager.getString("messaging", "deliveryInDoubt.details");
        _local2.faultCode = ErrorMessage.MESSAGE_DELIVERY_IN_DOUBT;
        _local2.rootCause = _arg1;
        agent.fault(_local2, message);
    }

    protected function channelFaultHandler(_arg1:ChannelFaultEvent):void
    {
        if (this.handled)
        {
            return;
        };
        this.disconnect();
        var _local2:ErrorMessage = _arg1.createErrorMessage();
        _local2.correlationId = message.messageId;
        if (!_arg1.channel.connected)
        {
            _local2.faultCode = ErrorMessage.MESSAGE_DELIVERY_IN_DOUBT;
        };
        _local2.rootCause = _arg1;
        agent.fault(_local2, message);
    }

    private function disconnect():void
    {
        this.handled = true;
        channel.removeEventListener(ChannelEvent.DISCONNECT, this.channelDisconnectHandler);
        channel.removeEventListener(ChannelFaultEvent.FAULT, this.channelFaultHandler);
    }


}
