//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.ProgressEvent;
    import mx.core.mx_internal;
    import flash.display.LoaderInfo;
    import flash.net.URLRequest;
    import flash.events.Event;

    use namespace mx_internal;

    public class RSLEvent extends ProgressEvent 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const RSL_ADD_PRELOADED:String = "rslAddPreloaded";
        public static const RSL_COMPLETE:String = "rslComplete";
        public static const RSL_ERROR:String = "rslError";
        public static const RSL_PROGRESS:String = "rslProgress";

        public var errorText:String;
        public var isResourceModule:Boolean;
        public var loaderInfo:LoaderInfo;
        public var rslIndex:int;
        public var rslTotal:int;
        public var url:URLRequest;

        public function RSLEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:int=-1, _arg5:int=-1, _arg6:int=-1, _arg7:int=-1, _arg8:URLRequest=null, _arg9:String=null, _arg10:Boolean=false, _arg11:LoaderInfo=null)
        {
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
            this.rslIndex = _arg6;
            this.rslTotal = _arg7;
            this.url = _arg8;
            this.errorText = _arg9;
            this.isResourceModule = _arg10;
            this.loaderInfo = _arg11;
        }

        override public function clone():Event
        {
            return (new RSLEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, this.rslIndex, this.rslTotal, this.url, this.errorText, this.isResourceModule, this.loaderInfo));
        }


    }
}//package mx.events
