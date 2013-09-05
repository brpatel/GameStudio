//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.channels
{
    import mx.messaging.Channel;
    import mx.core.mx_internal;
    import flash.utils.Timer;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import flash.events.TimerEvent;
    import mx.messaging.ChannelSet;
    import mx.messaging.MessageAgent;
    import mx.messaging.Consumer;
    import mx.messaging.ConsumerMessageDispatcher;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.messages.IMessage;
    import mx.logging.Log;
    import mx.messaging.events.ChannelFaultEvent;
    import mx.messaging.MessageResponder;
    import flash.events.Event;

    use namespace mx_internal;

    public class PollingChannel extends Channel 
    {

        protected static const POLLING_ENABLED:String = "polling-enabled";
        protected static const POLLING_INTERVAL_MILLIS:String = "polling-interval-millis";
        protected static const POLLING_INTERVAL_LEGACY:String = "polling-interval-seconds";
        protected static const PIGGYBACKING_ENABLED:String = "piggybacking-enabled";
        protected static const LOGIN_AFTER_DISCONNECT:String = "login-after-disconnect";
        private static const DEFAULT_POLLING_INTERVAL:int = 3000;

        mx_internal var _pollingInterval:int;
        mx_internal var _shouldPoll:Boolean;
        private var _pollingRef:int = -1;
        mx_internal var pollOutstanding:Boolean;
        mx_internal var _timer:Timer;
        private var resourceManager:IResourceManager;
        protected var _loginAfterDisconnect:Boolean;
        private var _piggybackingEnabled:Boolean;
        private var _pollingEnabled:Boolean;

        public function PollingChannel(_arg1:String=null, _arg2:String=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super(_arg1, _arg2);
            this._pollingEnabled = true;
            this._shouldPoll = false;
            if (this.timerRequired())
            {
                this._pollingInterval = DEFAULT_POLLING_INTERVAL;
                this._timer = new Timer(this._pollingInterval, 1);
                this._timer.addEventListener(TimerEvent.TIMER, this.internalPoll);
            };
        }

        override protected function setConnected(_arg1:Boolean):void
        {
            var _local2:ChannelSet;
            var _local3:MessageAgent;
            if (connected != _arg1)
            {
                if (_arg1)
                {
                    for each (_local2 in channelSets)
                    {
                        for each (_local3 in _local2.messageAgents)
                        {
                            if ((((_local3 is Consumer)) && ((_local3 as Consumer).subscribed)))
                            {
                                this.enablePolling();
                            };
                        };
                    };
                };
                super.setConnected(_arg1);
            };
        }

        mx_internal function get loginAfterDisconnect():Boolean
        {
            return (this._loginAfterDisconnect);
        }

        protected function get internalPiggybackingEnabled():Boolean
        {
            return (this._piggybackingEnabled);
        }

        protected function set internalPiggybackingEnabled(_arg1:Boolean):void
        {
            this._piggybackingEnabled = _arg1;
        }

        protected function get internalPollingEnabled():Boolean
        {
            return (this._pollingEnabled);
        }

        protected function set internalPollingEnabled(_arg1:Boolean):void
        {
            this._pollingEnabled = _arg1;
            if (((!(_arg1)) && (((this.timerRunning) || (((!(this.timerRunning)) && ((this._pollingInterval == 0))))))))
            {
                this.stopPolling();
            }
            else
            {
                if (((((_arg1) && (this._shouldPoll))) && (!(this.timerRunning))))
                {
                    this.startPolling();
                };
            };
        }

        mx_internal function get internalPollingInterval():Number
        {
            return ((((this._timer)==null) ? 0 : this._pollingInterval));
        }

        mx_internal function set internalPollingInterval(_arg1:Number):void
        {
            var _local2:String;
            if (_arg1 == 0)
            {
                this._pollingInterval = _arg1;
                if (this._timer != null)
                {
                    this._timer.stop();
                };
                if (this._shouldPoll)
                {
                    this.startPolling();
                };
            }
            else
            {
                if (_arg1 > 0)
                {
                    if (this._timer != null)
                    {
                        this._timer.delay = (this._pollingInterval = _arg1);
                        if (((!(this.timerRunning)) && (this._shouldPoll)))
                        {
                            this.startPolling();
                        };
                    };
                }
                else
                {
                    _local2 = this.resourceManager.getString("messaging", "pollingIntervalNonPositive");
                    throw (new ArgumentError(_local2));
                };
            };
        }

        override mx_internal function get realtime():Boolean
        {
            return (this._pollingEnabled);
        }

        mx_internal function get timerRunning():Boolean
        {
            return (((!((this._timer == null))) && (this._timer.running)));
        }

        override public function send(_arg1:MessageAgent, _arg2:IMessage):void
        {
            var consumerDispatcher:ConsumerMessageDispatcher;
            var msg:CommandMessage;
            var agent:MessageAgent = _arg1;
            var message:IMessage = _arg2;
            var piggyback:Boolean;
            if (((((!(this.pollOutstanding)) && (this._piggybackingEnabled))) && (!((message is CommandMessage)))))
            {
                if (this._shouldPoll)
                {
                    piggyback = true;
                }
                else
                {
                    consumerDispatcher = ConsumerMessageDispatcher.getInstance();
                    if (consumerDispatcher.isChannelUsedForSubscriptions(this))
                    {
                        piggyback = true;
                    };
                };
            };
            if (piggyback)
            {
                this.internalPoll();
            };
            super.send(agent, message);
            if (piggyback)
            {
                msg = new CommandMessage();
                msg.operation = CommandMessage.POLL_OPERATION;
                if (Log.isDebug())
                {
                    _log.debug("'{0}' channel sending poll message\n{1}\n", id, msg.toString());
                };
                try
                {
                    internalSend(new PollCommandMessageResponder(null, msg, this, _log));
                }
                catch(e:Error)
                {
                    stopPolling();
                    throw (e);
                };
            };
        }

        override protected function connectFailed(_arg1:ChannelFaultEvent):void
        {
            this.stopPolling();
            super.connectFailed(_arg1);
        }

        final override protected function getMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder
        {
            if ((((_arg2 is CommandMessage)) && (((_arg2 as CommandMessage).operation == CommandMessage.POLL_OPERATION))))
            {
                return (new PollCommandMessageResponder(_arg1, _arg2, this, _log));
            };
            return (this.getDefaultMessageResponder(_arg1, _arg2));
        }

        override protected function internalDisconnect(_arg1:Boolean=false):void
        {
            this.stopPolling();
            super.internalDisconnect(_arg1);
        }

        public function enablePolling():void
        {
            this._pollingRef++;
            if (this._pollingRef == 0)
            {
                this.startPolling();
            };
        }

        public function disablePolling():void
        {
            this._pollingRef--;
            if (this._pollingRef < 0)
            {
                this.stopPolling();
            };
        }

        public function poll():void
        {
            this.internalPoll();
        }

        mx_internal function pollFailed(_arg1:Boolean=false):void
        {
            this.internalDisconnect(_arg1);
        }

        mx_internal function stopPolling():void
        {
            if (Log.isInfo())
            {
                _log.info("'{0}' channel polling stopped.", id);
            };
            if (this._timer != null)
            {
                this._timer.stop();
            };
            this._pollingRef = -1;
            this._shouldPoll = false;
            this.pollOutstanding = false;
        }

        protected function applyPollingSettings(_arg1:XML):void
        {
            if (_arg1.properties.length() == 0)
            {
                return;
            };
            var _local2:XML = _arg1.properties[0];
            if (_local2[POLLING_ENABLED].length() != 0)
            {
                this.internalPollingEnabled = (_local2[POLLING_ENABLED].toString() == TRUE);
            };
            if (_local2[POLLING_INTERVAL_MILLIS].length() != 0)
            {
                this.internalPollingInterval = parseInt(_local2[POLLING_INTERVAL_MILLIS].toString());
            }
            else
            {
                if (_local2[POLLING_INTERVAL_LEGACY].length() != 0)
                {
                    this.internalPollingInterval = (parseInt(_local2[POLLING_INTERVAL_LEGACY].toString()) * 1000);
                };
            };
            if (_local2[PIGGYBACKING_ENABLED].length() != 0)
            {
                this.internalPiggybackingEnabled = (_local2[PIGGYBACKING_ENABLED].toString() == TRUE);
            };
            if (_local2[LOGIN_AFTER_DISCONNECT].length() != 0)
            {
                this._loginAfterDisconnect = (_local2[LOGIN_AFTER_DISCONNECT].toString() == TRUE);
            };
        }

        protected function getDefaultMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder
        {
            return (super.getMessageResponder(_arg1, _arg2));
        }

        protected function internalPoll(_arg1:Event=null):void
        {
            var poll:CommandMessage;
            var event = _arg1;
            if (!this.pollOutstanding)
            {
                if (Log.isInfo())
                {
                    _log.info("'{0}' channel requesting queued messages.", id);
                };
                if (this.timerRunning)
                {
                    this._timer.stop();
                };
                poll = new CommandMessage();
                poll.operation = CommandMessage.POLL_OPERATION;
                if (Log.isDebug())
                {
                    _log.debug("'{0}' channel sending poll message\n{1}\n", id, poll.toString());
                };
                try
                {
                    internalSend(new PollCommandMessageResponder(null, poll, this, _log));
                    this.pollOutstanding = true;
                }
                catch(e:Error)
                {
                    stopPolling();
                    throw (e);
                };
            }
            else
            {
                if (Log.isInfo())
                {
                    _log.info("'{0}' channel waiting for poll response.", id);
                };
            };
        }

        protected function startPolling():void
        {
            if (this._pollingEnabled)
            {
                if (Log.isInfo())
                {
                    _log.info("'{0}' channel polling started.", id);
                };
                this._shouldPoll = true;
                this.poll();
            };
        }

        protected function timerRequired():Boolean
        {
            return (true);
        }


    }
}//package mx.messaging.channels

import mx.messaging.MessageResponder;
import mx.logging.ILogger;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.events.PropertyChangeEvent;
import mx.messaging.MessageAgent;
import mx.messaging.messages.IMessage;
import mx.messaging.channels.PollingChannel;
import mx.messaging.messages.MessagePerformanceUtils;
import mx.messaging.messages.ErrorMessage;
import mx.logging.Log;
import mx.messaging.messages.CommandMessage;
import mx.core.mx_internal;
import mx.messaging.events.MessageEvent;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.events.ChannelFaultEvent;

use namespace mx_internal;

class PollCommandMessageResponder extends MessageResponder 
{

    private var _log:ILogger;
    private var resourceManager:IResourceManager;
    private var suppressHandlers:Boolean;

    public function PollCommandMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:PollingChannel, _arg4:ILogger)
    {
        this.resourceManager = ResourceManager.getInstance();
        super(_arg1, _arg2, _arg3);
        this._log = _arg4;
        _arg3.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.channelPropertyChangeHandler);
    }

    override protected function resultHandler(_arg1:IMessage):void
    {
        var messageList:Array;
        var message:IMessage;
        var mpiutil:MessagePerformanceUtils;
        var errMsg:ErrorMessage;
        var msg:IMessage = _arg1;
        var pollingChannel:PollingChannel = (channel as PollingChannel);
        channel.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.channelPropertyChangeHandler);
        if (this.suppressHandlers)
        {
            if (Log.isDebug())
            {
                this._log.debug("'{0}' channel ignoring response for poll request preceeding most recent disconnect.\n", channel.id);
            };
            this.doPoll();
            return;
        };
        if ((msg is CommandMessage))
        {
            pollingChannel.pollOutstanding = false;
            if (msg.headers[CommandMessage.NO_OP_POLL_HEADER] == true)
            {
                return;
            };
            if (msg.body != null)
            {
                messageList = (msg.body as Array);
                for each (message in messageList)
                {
                    if (Log.isDebug())
                    {
                        this._log.debug("'{0}' channel got message\n{1}\n", channel.id, message.toString());
                        if (channel.mpiEnabled)
                        {
                            try
                            {
                                mpiutil = new MessagePerformanceUtils(message);
                                this._log.debug(mpiutil.prettyPrint());
                            }
                            catch(e:Error)
                            {
                                _log.debug(("Could not get message performance information for: " + msg.toString()));
                            };
                        };
                    };
                    channel.dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE, message));
                };
            };
        }
        else
        {
            if ((msg is AcknowledgeMessage))
            {
                pollingChannel.pollOutstanding = false;
            }
            else
            {
                errMsg = new ErrorMessage();
                errMsg.faultDetail = this.resourceManager.getString("messaging", "receivedNull");
                status(errMsg);
                return;
            };
        };
        if (msg.headers[CommandMessage.POLL_WAIT_HEADER] != null)
        {
            this.doPoll(msg.headers[CommandMessage.POLL_WAIT_HEADER]);
        }
        else
        {
            this.doPoll();
        };
    }

    override protected function statusHandler(_arg1:IMessage):void
    {
        channel.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.channelPropertyChangeHandler);
        if (this.suppressHandlers)
        {
            if (Log.isDebug())
            {
                this._log.debug("'{0}' channel ignoring response for poll request preceeding most recent disconnect.\n", channel.id);
            };
            return;
        };
        var _local2:PollingChannel = PollingChannel(channel);
        _local2.stopPolling();
        var _local3:ErrorMessage = (_arg1 as ErrorMessage);
        var _local4:String = (((_local3)!=null) ? _local3.faultDetail : "");
        var _local5:ChannelFaultEvent = ChannelFaultEvent.createEvent(_local2, false, "Channel.Polling.Error", "error", _local4);
        _local5.rootCause = _arg1;
        _local2.dispatchEvent(_local5);
        if (((!((_local3 == null))) && ((_local3.faultCode == "Server.PollNotSupported"))))
        {
            _local2.pollFailed(true);
        }
        else
        {
            _local2.pollFailed(false);
        };
    }

    private function channelPropertyChangeHandler(_arg1:PropertyChangeEvent):void
    {
        if ((((_arg1.property == "connected")) && (!(_arg1.newValue))))
        {
            this.suppressHandlers = true;
        };
    }

    private function doPoll(_arg1:int=0):void
    {
        var _local2:PollingChannel = PollingChannel(channel);
        if (((_local2.connected) && (_local2._shouldPoll)))
        {
            if (_arg1 == 0)
            {
                if (_local2.internalPollingInterval == 0)
                {
                    _local2.poll();
                }
                else
                {
                    if (!_local2.timerRunning)
                    {
                        _local2._timer.delay = _local2._pollingInterval;
                        _local2._timer.start();
                    };
                };
            }
            else
            {
                _local2._timer.delay = _arg1;
                _local2._timer.start();
            };
        };
    }


}
