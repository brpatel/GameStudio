//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.ProgressEvent;
    import mx.core.mx_internal;
    import flash.events.Event;

    use namespace mx_internal;

    public class StyleEvent extends ProgressEvent 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const COMPLETE:String = "complete";
        public static const ERROR:String = "error";
        public static const PROGRESS:String = "progress";

        public var errorText:String;

        public function StyleEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:uint=0, _arg5:uint=0, _arg6:String=null)
        {
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
            this.errorText = _arg6;
        }

        override public function clone():Event
        {
            return (new StyleEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, this.errorText));
        }


    }
}//package mx.events
