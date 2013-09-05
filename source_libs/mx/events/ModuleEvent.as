//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.ProgressEvent;
    import mx.core.mx_internal;
    import mx.modules.IModuleInfo;
    import flash.events.Event;

    use namespace mx_internal;

    public class ModuleEvent extends ProgressEvent 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const ERROR:String = "error";
        public static const PROGRESS:String = "progress";
        public static const READY:String = "ready";
        public static const SETUP:String = "setup";
        public static const UNLOAD:String = "unload";

        public var errorText:String;
        private var _module:IModuleInfo;

        public function ModuleEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:uint=0, _arg5:uint=0, _arg6:String=null, _arg7:IModuleInfo=null)
        {
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
            this.errorText = _arg6;
            this._module = _arg7;
        }

        public function get module():IModuleInfo
        {
            if (this._module)
            {
                return (this._module);
            };
            return ((target as IModuleInfo));
        }

        override public function clone():Event
        {
            return (new ModuleEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, this.errorText, this.module));
        }


    }
}//package mx.events
