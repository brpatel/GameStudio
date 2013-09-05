//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.messages
{
    import flash.utils.ByteArray;
    import mx.utils.RPCUIDUtil;
    import flash.utils.IDataInput;
    import mx.utils.RPCObjectUtil;
    import flash.utils.IDataOutput;
    import flash.utils.getQualifiedClassName;
    import mx.utils.RPCStringUtil;

    public class AbstractMessage implements IMessage 
    {

        public static const DESTINATION_CLIENT_ID_HEADER:String = "DSDstClientId";
        public static const ENDPOINT_HEADER:String = "DSEndpoint";
        public static const FLEX_CLIENT_ID_HEADER:String = "DSId";
        public static const PRIORITY_HEADER:String = "DSPriority";
        public static const REMOTE_CREDENTIALS_HEADER:String = "DSRemoteCredentials";
        public static const REMOTE_CREDENTIALS_CHARSET_HEADER:String = "DSRemoteCredentialsCharset";
        public static const REQUEST_TIMEOUT_HEADER:String = "DSRequestTimeout";
        public static const STATUS_CODE_HEADER:String = "DSStatusCode";
        private static const HAS_NEXT_FLAG:uint = 128;
        private static const BODY_FLAG:uint = 1;
        private static const CLIENT_ID_FLAG:uint = 2;
        private static const DESTINATION_FLAG:uint = 4;
        private static const HEADERS_FLAG:uint = 8;
        private static const MESSAGE_ID_FLAG:uint = 16;
        private static const TIMESTAMP_FLAG:uint = 32;
        private static const TIME_TO_LIVE_FLAG:uint = 64;
        private static const CLIENT_ID_BYTES_FLAG:uint = 1;
        private static const MESSAGE_ID_BYTES_FLAG:uint = 2;

        private var _body:Object;
        private var _clientId:String;
        private var clientIdBytes:ByteArray;
        private var _destination:String = "";
        private var _headers:Object;
        private var _messageId:String;
        private var messageIdBytes:ByteArray;
        private var _timestamp:Number = 0;
        private var _timeToLive:Number = 0;

        public function AbstractMessage()
        {
            this._body = {};
            super();
        }

        public function get body():Object
        {
            return (this._body);
        }

        public function set body(_arg1:Object):void
        {
            this._body = _arg1;
        }

        public function get clientId():String
        {
            return (this._clientId);
        }

        public function set clientId(_arg1:String):void
        {
            this._clientId = _arg1;
            this.clientIdBytes = null;
        }

        public function get destination():String
        {
            return (this._destination);
        }

        public function set destination(_arg1:String):void
        {
            this._destination = _arg1;
        }

        public function get headers():Object
        {
            if (this._headers == null)
            {
                this._headers = {};
            };
            return (this._headers);
        }

        public function set headers(_arg1:Object):void
        {
            this._headers = _arg1;
        }

        public function get messageId():String
        {
            if (this._messageId == null)
            {
                this._messageId = RPCUIDUtil.createUID();
            };
            return (this._messageId);
        }

        public function set messageId(_arg1:String):void
        {
            this._messageId = _arg1;
            this.messageIdBytes = null;
        }

        public function get timestamp():Number
        {
            return (this._timestamp);
        }

        public function set timestamp(_arg1:Number):void
        {
            this._timestamp = _arg1;
        }

        public function get timeToLive():Number
        {
            return (this._timeToLive);
        }

        public function set timeToLive(_arg1:Number):void
        {
            this._timeToLive = _arg1;
        }

        public function readExternal(_arg1:IDataInput):void
        {
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local2:Array = this.readFlags(_arg1);
            var _local3:uint;
            while (_local3 < _local2.length)
            {
                _local4 = (_local2[_local3] as uint);
                _local5 = 0;
                if (_local3 == 0)
                {
                    if ((_local4 & BODY_FLAG) != 0)
                    {
                        this.readExternalBody(_arg1);
                    }
                    else
                    {
                        this.body = null;
                    };
                    if ((_local4 & CLIENT_ID_FLAG) != 0)
                    {
                        this.clientId = _arg1.readObject();
                    };
                    if ((_local4 & DESTINATION_FLAG) != 0)
                    {
                        this.destination = (_arg1.readObject() as String);
                    };
                    if ((_local4 & HEADERS_FLAG) != 0)
                    {
                        this.headers = _arg1.readObject();
                    };
                    if ((_local4 & MESSAGE_ID_FLAG) != 0)
                    {
                        this.messageId = (_arg1.readObject() as String);
                    };
                    if ((_local4 & TIMESTAMP_FLAG) != 0)
                    {
                        this.timestamp = (_arg1.readObject() as Number);
                    };
                    if ((_local4 & TIME_TO_LIVE_FLAG) != 0)
                    {
                        this.timeToLive = (_arg1.readObject() as Number);
                    };
                    _local5 = 7;
                }
                else
                {
                    if (_local3 == 1)
                    {
                        if ((_local4 & CLIENT_ID_BYTES_FLAG) != 0)
                        {
                            this.clientIdBytes = (_arg1.readObject() as ByteArray);
                            this.clientId = RPCUIDUtil.fromByteArray(this.clientIdBytes);
                        };
                        if ((_local4 & MESSAGE_ID_BYTES_FLAG) != 0)
                        {
                            this.messageIdBytes = (_arg1.readObject() as ByteArray);
                            this.messageId = RPCUIDUtil.fromByteArray(this.messageIdBytes);
                        };
                        _local5 = 2;
                    };
                };
                if ((_local4 >> _local5) != 0)
                {
                    _local6 = _local5;
                    while (_local6 < 6)
                    {
                        if (((_local4 >> _local6) & 1) != 0)
                        {
                            _arg1.readObject();
                        };
                        _local6++;
                    };
                };
                _local3++;
            };
        }

        public function toString():String
        {
            return (RPCObjectUtil.toString(this));
        }

        public function writeExternal(_arg1:IDataOutput):void
        {
            var _local2:uint;
            var _local3:String = this.messageId;
            if (this.clientIdBytes == null)
            {
                this.clientIdBytes = RPCUIDUtil.toByteArray(this._clientId);
            };
            if (this.messageIdBytes == null)
            {
                this.messageIdBytes = RPCUIDUtil.toByteArray(this._messageId);
            };
            if (this.body != null)
            {
                _local2 = (_local2 | BODY_FLAG);
            };
            if (((!((this.clientId == null))) && ((this.clientIdBytes == null))))
            {
                _local2 = (_local2 | CLIENT_ID_FLAG);
            };
            if (this.destination != null)
            {
                _local2 = (_local2 | DESTINATION_FLAG);
            };
            if (this.headers != null)
            {
                _local2 = (_local2 | HEADERS_FLAG);
            };
            if (((!((this.messageId == null))) && ((this.messageIdBytes == null))))
            {
                _local2 = (_local2 | MESSAGE_ID_FLAG);
            };
            if (this.timestamp != 0)
            {
                _local2 = (_local2 | TIMESTAMP_FLAG);
            };
            if (this.timeToLive != 0)
            {
                _local2 = (_local2 | TIME_TO_LIVE_FLAG);
            };
            if (((!((this.clientIdBytes == null))) || (!((this.messageIdBytes == null)))))
            {
                _local2 = (_local2 | HAS_NEXT_FLAG);
            };
            _arg1.writeByte(_local2);
            _local2 = 0;
            if (this.clientIdBytes != null)
            {
                _local2 = (_local2 | CLIENT_ID_BYTES_FLAG);
            };
            if (this.messageIdBytes != null)
            {
                _local2 = (_local2 | MESSAGE_ID_BYTES_FLAG);
            };
            if (_local2 != 0)
            {
                _arg1.writeByte(_local2);
            };
            if (this.body != null)
            {
                this.writeExternalBody(_arg1);
            };
            if (((!((this.clientId == null))) && ((this.clientIdBytes == null))))
            {
                _arg1.writeObject(this.clientId);
            };
            if (this.destination != null)
            {
                _arg1.writeObject(this.destination);
            };
            if (this.headers != null)
            {
                _arg1.writeObject(this.headers);
            };
            if (((!((this.messageId == null))) && ((this.messageIdBytes == null))))
            {
                _arg1.writeObject(this.messageId);
            };
            if (this.timestamp != 0)
            {
                _arg1.writeObject(this.timestamp);
            };
            if (this.timeToLive != 0)
            {
                _arg1.writeObject(this.timeToLive);
            };
            if (this.clientIdBytes != null)
            {
                _arg1.writeObject(this.clientIdBytes);
            };
            if (this.messageIdBytes != null)
            {
                _arg1.writeObject(this.messageIdBytes);
            };
        }

        protected function addDebugAttributes(_arg1:Object):void
        {
            _arg1["body"] = this.body;
            _arg1["clientId"] = this.clientId;
            _arg1["destination"] = this.destination;
            _arg1["headers"] = this.headers;
            _arg1["messageId"] = this.messageId;
            _arg1["timestamp"] = this.timestamp;
            _arg1["timeToLive"] = this.timeToLive;
        }

        final protected function getDebugString():String
        {
            var _local4:String;
            var _local5:uint;
            var _local6:String;
            var _local7:String;
            var _local1 = (("(" + getQualifiedClassName(this)) + ")");
            var _local2:Object = {};
            this.addDebugAttributes(_local2);
            var _local3:Array = [];
            for (_local4 in _local2)
            {
                _local3.push(_local4);
            };
            _local3.sort();
            _local5 = 0;
            while (_local5 < _local3.length)
            {
                _local6 = String(_local3[_local5]);
                _local7 = RPCObjectUtil.toString(_local2[_local6]);
                _local1 = (_local1 + RPCStringUtil.substitute("\n  {0}={1}", _local6, _local7));
                _local5++;
            };
            return (_local1);
        }

        protected function readExternalBody(_arg1:IDataInput):void
        {
            this.body = _arg1.readObject();
        }

        protected function readFlags(_arg1:IDataInput):Array
        {
            var _local4:uint;
            var _local2:Boolean = true;
            var _local3:Array = [];
            while (((_local2) && ((_arg1.bytesAvailable > 0))))
            {
                _local4 = _arg1.readUnsignedByte();
                _local3.push(_local4);
                if ((_local4 & HAS_NEXT_FLAG) != 0)
                {
                    _local2 = true;
                }
                else
                {
                    _local2 = false;
                };
            };
            return (_local3);
        }

        protected function writeExternalBody(_arg1:IDataOutput):void
        {
            _arg1.writeObject(this.body);
        }


    }
}//package mx.messaging.messages
