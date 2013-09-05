//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.logging
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class LogEvent extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const LOG:String = "log";

        public var level:int;
        public var message:String;

        public function LogEvent(_arg1:String="", _arg2:int=0)
        {
            super(LogEvent.LOG, false, false);
            this.message = _arg1;
            this.level = _arg2;
        }

        public static function getLevelString(_arg1:uint):String
        {
            switch (_arg1)
            {
                case LogEventLevel.INFO:
                    return ("INFO");
                case LogEventLevel.DEBUG:
                    return ("DEBUG");
                case LogEventLevel.ERROR:
                    return ("ERROR");
                case LogEventLevel.WARN:
                    return ("WARN");
                case LogEventLevel.FATAL:
                    return ("FATAL");
                case LogEventLevel.ALL:
                    return ("ALL");
            };
            return ("UNKNOWN");
        }


        override public function clone():Event
        {
            return (new LogEvent(this.message, this.level));
        }


    }
}//package mx.logging
