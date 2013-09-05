//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import flash.utils.Dictionary;
    import mx.messaging.events.MessageEvent;
    import mx.logging.Log;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class ConsumerMessageDispatcher 
    {

        private static var _instance:ConsumerMessageDispatcher;

        private const _consumers:Object = {};
        private const _channelSetRefCounts:Dictionary = new Dictionary();
        private const _consumerDuplicateMessageBarrier:Object = {};


        public static function getInstance():ConsumerMessageDispatcher
        {
            if (!_instance)
            {
                _instance = new (ConsumerMessageDispatcher)();
            };
            return (_instance);
        }


        public function isChannelUsedForSubscriptions(_arg1:Channel):Boolean
        {
            var _local2:Array = _arg1.channelSets;
            var _local3:ChannelSet;
            var _local4:int = _local2.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                _local3 = _local2[_local5];
                if (((!((this._channelSetRefCounts[_local3] == null))) && ((_local3.currentChannel == _arg1))))
                {
                    return (true);
                };
                _local5++;
            };
            return (false);
        }

        public function registerSubscription(_arg1:AbstractConsumer):void
        {
            this._consumers[_arg1.clientId] = _arg1;
            if (this._channelSetRefCounts[_arg1.channelSet] == null)
            {
                _arg1.channelSet.addEventListener(MessageEvent.MESSAGE, this.messageHandler);
                this._channelSetRefCounts[_arg1.channelSet] = 1;
            }
            else
            {
                var _local2 = this._channelSetRefCounts;
                var _local3 = _arg1.channelSet;
                var _local4 = (_local2[_local3] + 1);
                _local2[_local3] = _local4;
            };
        }

        public function unregisterSubscription(_arg1:AbstractConsumer):void
        {
            delete this._consumers[_arg1.clientId];
            var _local2:int = this._channelSetRefCounts[_arg1.channelSet];
            --_local2;
            if (_local2 == 0)
            {
                _arg1.channelSet.removeEventListener(MessageEvent.MESSAGE, this.messageHandler);
                delete this._channelSetRefCounts[_arg1.channelSet];
                if (this._consumerDuplicateMessageBarrier[_arg1.id] != null)
                {
                    delete this._consumerDuplicateMessageBarrier[_arg1.id];
                };
            }
            else
            {
                this._channelSetRefCounts[_arg1.channelSet] = _local2;
            };
        }

        private function messageHandler(_arg1:MessageEvent):void
        {
            var _local3:int;
            var _local4:ChannelSet;
            var _local5:Array;
            var _local2:AbstractConsumer = this._consumers[_arg1.message.clientId];
            if (_local2 == null)
            {
                if (Log.isDebug())
                {
                    Log.getLogger("mx.messaging.Consumer").debug("'{0}' received pushed message for consumer but no longer subscribed: {1}", _arg1.message.clientId, _arg1.message);
                };
                return;
            };
            if (_arg1.target.currentChannel.channelSets.length > 1)
            {
                _local3 = 0;
                for each (_local4 in _arg1.target.currentChannel.channelSets)
                {
                    if (this._channelSetRefCounts[_local4] != null)
                    {
                        _local3++;
                    };
                };
                if (_local3 > 1)
                {
                    if (this._consumerDuplicateMessageBarrier[_local2.id] == null)
                    {
                        this._consumerDuplicateMessageBarrier[_local2.id] = [_arg1.messageId, _local3];
                        _local2.messageHandler(_arg1);
                    };
                    _local5 = this._consumerDuplicateMessageBarrier[_local2.id];
                    if (_local5[0] == _arg1.messageId)
                    {
                        var _local6 = _local5;
                        var _local7:int = 1;
                        var _local8 = (_local6[_local7] - 1);
                        _local6[_local7] = _local8;
                        if (_local8 == 0)
                        {
                            delete this._consumerDuplicateMessageBarrier[_local2.id];
                        };
                    };
                    return;
                };
            };
            _local2.messageHandler(_arg1);
        }


    }
}//package mx.messaging
