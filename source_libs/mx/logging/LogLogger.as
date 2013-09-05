//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.logging
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;

    use namespace mx_internal;

    public class LogLogger extends EventDispatcher implements ILogger 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var resourceManager:IResourceManager;
        private var _category:String;

        public function LogLogger(_arg1:String)
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this._category = _arg1;
        }

        public function get category():String
        {
            return (this._category);
        }

        public function log(_arg1:int, _arg2:String, ... _args):void
        {
            var _local4:String;
            var _local5:int;
            if (_arg1 < LogEventLevel.DEBUG)
            {
                _local4 = this.resourceManager.getString("logging", "levelLimit");
                throw (new ArgumentError(_local4));
            };
            if (hasEventListener(LogEvent.LOG))
            {
                _local5 = 0;
                while (_local5 < _args.length)
                {
                    _arg2 = _arg2.replace(new RegExp((("\\{" + _local5) + "\\}"), "g"), _args[_local5]);
                    _local5++;
                };
                dispatchEvent(new LogEvent(_arg2, _arg1));
            };
        }

        public function debug(_arg1:String, ... _args):void
        {
            var _local3:int;
            if (hasEventListener(LogEvent.LOG))
            {
                _local3 = 0;
                while (_local3 < _args.length)
                {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.DEBUG));
            };
        }

        public function error(_arg1:String, ... _args):void
        {
            var _local3:int;
            if (hasEventListener(LogEvent.LOG))
            {
                _local3 = 0;
                while (_local3 < _args.length)
                {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.ERROR));
            };
        }

        public function fatal(_arg1:String, ... _args):void
        {
            var _local3:int;
            if (hasEventListener(LogEvent.LOG))
            {
                _local3 = 0;
                while (_local3 < _args.length)
                {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.FATAL));
            };
        }

        public function info(_arg1:String, ... _args):void
        {
            var _local3:int;
            if (hasEventListener(LogEvent.LOG))
            {
                _local3 = 0;
                while (_local3 < _args.length)
                {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.INFO));
            };
        }

        public function warn(_arg1:String, ... _args):void
        {
            var _local3:int;
            if (hasEventListener(LogEvent.LOG))
            {
                _local3 = 0;
                while (_local3 < _args.length)
                {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.WARN));
            };
        }


    }
}//package mx.logging
