﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.events
{
    import flash.events.Event;
    import mx.messaging.Channel;

    public class ChannelEvent extends Event 
    {

        public static const CONNECT:String = "channelConnect";
        public static const DISCONNECT:String = "channelDisconnect";

        public var channel:Channel;
        public var connected:Boolean;
        public var reconnecting:Boolean;
        public var rejected:Boolean;

        public function ChannelEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Channel=null, _arg5:Boolean=false, _arg6:Boolean=false, _arg7:Boolean=false)
        {
            super(_arg1, _arg2, _arg3);
            this.channel = _arg4;
            this.reconnecting = _arg5;
            this.rejected = _arg6;
            this.connected = _arg7;
        }

        public static function createEvent(_arg1:String, _arg2:Channel=null, _arg3:Boolean=false, _arg4:Boolean=false, _arg5:Boolean=false):ChannelEvent
        {
            return (new ChannelEvent(_arg1, false, false, _arg2, _arg3, _arg4, _arg5));
        }


        public function get channelId():String
        {
            if (this.channel != null)
            {
                return (this.channel.id);
            };
            return (null);
        }

        override public function clone():Event
        {
            return (new ChannelEvent(type, bubbles, cancelable, this.channel, this.reconnecting, this.rejected, this.connected));
        }

        override public function toString():String
        {
            return (formatToString("ChannelEvent", "channelId", "reconnecting", "rejected", "type", "bubbles", "cancelable", "eventPhase"));
        }


    }
}//package mx.messaging.events
