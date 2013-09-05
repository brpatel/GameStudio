//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class ValidationResultEvent extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const INVALID:String = "invalid";
        public static const VALID:String = "valid";

        public var field:String;
        public var results:Array;

        public function ValidationResultEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:Array=null)
        {
            super(_arg1, _arg2, _arg3);
            this.field = _arg4;
            this.results = _arg5;
        }

        public function get message():String
        {
            var _local1 = "";
            var _local2:int = this.results.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                if (this.results[_local3].isError)
                {
                    _local1 = (_local1 + (((_local1 == "")) ? "" : "\n"));
                    _local1 = (_local1 + this.results[_local3].errorMessage);
                };
                _local3++;
            };
            return (_local1);
        }

        override public function clone():Event
        {
            return (new ValidationResultEvent(type, bubbles, cancelable, this.field, this.results));
        }


    }
}//package mx.events
