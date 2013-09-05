//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class Request extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const GET_PARENT_FLEX_MODULE_FACTORY_REQUEST:String = "getParentFlexModuleFactoryRequest";

        public var value:Object;

        public function Request(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Object=null)
        {
            super(_arg1, _arg2, _arg3);
            this.value = _arg4;
        }

        override public function clone():Event
        {
            var _local1:Request = new Request(type, bubbles, cancelable, this.value);
            return (_local1);
        }


    }
}//package mx.events
