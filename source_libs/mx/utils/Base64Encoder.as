//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import flash.utils.ByteArray;

    public class Base64Encoder 
    {

        public static const CHARSET_UTF_8:String = "UTF-8";
        public static const MAX_BUFFER_SIZE:uint = 32767;
        private static const ESCAPE_CHAR_CODE:Number = 61;
        private static const ALPHABET_CHAR_CODES:Array = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47];

        public static var newLine:int = 10;

        public var insertNewLines:Boolean = true;
        private var _buffers:Array;
        private var _count:uint;
        private var _line:uint;
        private var _work:Array;

        public function Base64Encoder()
        {
            this._work = [0, 0, 0];
            super();
            this.reset();
        }

        public function drain():String
        {
            var _local3:Array;
            var _local1 = "";
            var _local2:uint;
            while (_local2 < this._buffers.length)
            {
                _local3 = (this._buffers[_local2] as Array);
                _local1 = (_local1 + String.fromCharCode.apply(null, _local3));
                _local2++;
            };
            this._buffers = [];
            this._buffers.push([]);
            return (_local1);
        }

        public function encode(_arg1:String, _arg2:uint=0, _arg3:uint=0):void
        {
            if (_arg3 == 0)
            {
                _arg3 = _arg1.length;
            };
            var _local4:uint = _arg2;
            var _local5:uint = (_arg2 + _arg3);
            if (_local5 > _arg1.length)
            {
                _local5 = _arg1.length;
            };
            while (_local4 < _local5)
            {
                this._work[this._count] = _arg1.charCodeAt(_local4);
                this._count++;
                if ((((this._count == this._work.length)) || (((_local5 - _local4) == 1))))
                {
                    this.encodeBlock();
                    this._count = 0;
                    this._work[0] = 0;
                    this._work[1] = 0;
                    this._work[2] = 0;
                };
                _local4++;
            };
        }

        public function encodeUTFBytes(_arg1:String):void
        {
            var _local2:ByteArray = new ByteArray();
            _local2.writeUTFBytes(_arg1);
            _local2.position = 0;
            this.encodeBytes(_local2);
        }

        public function encodeBytes(_arg1:ByteArray, _arg2:uint=0, _arg3:uint=0):void
        {
            if (_arg3 == 0)
            {
                _arg3 = _arg1.length;
            };
            var _local4:uint = _arg1.position;
            _arg1.position = _arg2;
            var _local5:uint = _arg2;
            var _local6:uint = (_arg2 + _arg3);
            if (_local6 > _arg1.length)
            {
                _local6 = _arg1.length;
            };
            while (_local5 < _local6)
            {
                this._work[this._count] = _arg1[_local5];
                this._count++;
                if ((((this._count == this._work.length)) || (((_local6 - _local5) == 1))))
                {
                    this.encodeBlock();
                    this._count = 0;
                    this._work[0] = 0;
                    this._work[1] = 0;
                    this._work[2] = 0;
                };
                _local5++;
            };
            _arg1.position = _local4;
        }

        public function flush():String
        {
            if (this._count > 0)
            {
                this.encodeBlock();
            };
            var _local1:String = this.drain();
            this.reset();
            return (_local1);
        }

        public function reset():void
        {
            this._buffers = [];
            this._buffers.push([]);
            this._count = 0;
            this._line = 0;
            this._work[0] = 0;
            this._work[1] = 0;
            this._work[2] = 0;
        }

        public function toString():String
        {
            return (this.flush());
        }

        private function encodeBlock():void
        {
            var _local1:Array = (this._buffers[(this._buffers.length - 1)] as Array);
            if (_local1.length >= MAX_BUFFER_SIZE)
            {
                _local1 = [];
                this._buffers.push(_local1);
            };
            _local1.push(ALPHABET_CHAR_CODES[((this._work[0] & 0xFF) >> 2)]);
            _local1.push(ALPHABET_CHAR_CODES[(((this._work[0] & 3) << 4) | ((this._work[1] & 240) >> 4))]);
            if (this._count > 1)
            {
                _local1.push(ALPHABET_CHAR_CODES[(((this._work[1] & 15) << 2) | ((this._work[2] & 192) >> 6))]);
            }
            else
            {
                _local1.push(ESCAPE_CHAR_CODE);
            };
            if (this._count > 2)
            {
                _local1.push(ALPHABET_CHAR_CODES[(this._work[2] & 63)]);
            }
            else
            {
                _local1.push(ESCAPE_CHAR_CODE);
            };
            if (this.insertNewLines)
            {
                if ((this._line = (this._line + 4)) == 76)
                {
                    _local1.push(newLine);
                    this._line = 0;
                };
            };
        }


    }
}//package mx.utils
