//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.messages
{
    public class MessagePerformanceInfo 
    {

        public var messageSize:int;
        public var sendTime:Number = 0;
        private var _receiveTime:Number;
        public var overheadTime:Number;
        private var _infoType:String;
        public var pushedFlag:Boolean;
        public var serverPrePushTime:Number;
        public var serverPreAdapterTime:Number;
        public var serverPostAdapterTime:Number;
        public var serverPreAdapterExternalTime:Number;
        public var serverPostAdapterExternalTime:Number;
        public var recordMessageTimes:Boolean;
        public var recordMessageSizes:Boolean;


        public function set infoType(_arg1:String):void
        {
            var _local2:Date;
            this._infoType = _arg1;
            if (this._infoType == "OUT")
            {
                _local2 = new Date();
                this._receiveTime = _local2.getTime();
            };
        }

        public function get infoType():String
        {
            return (this._infoType);
        }

        public function set receiveTime(_arg1:Number):void
        {
            if ((((this._infoType == null)) || (!((this._infoType == "OUT")))))
            {
                this._receiveTime = _arg1;
            };
        }

        public function get receiveTime():Number
        {
            return (this._receiveTime);
        }


    }
}//package mx.messaging.messages
