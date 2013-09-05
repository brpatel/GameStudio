//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.netmon
{
    import flash.net.URLRequest;
    import flash.events.Event;

    public class NetworkMonitor 
    {

        public static var isMonitoringImpl:Function;
        public static var adjustURLRequestImpl:Function;
        public static var adjustNetConnectionURLImpl:Function;
        public static var monitorEventImpl:Function;
        public static var monitorInvocationImpl:Function;
        public static var monitorResultImpl:Function;
        public static var monitorFaultImpl:Function;


        public static function isMonitoring():Boolean
        {
            return ((((isMonitoringImpl)!=null) ? isMonitoringImpl() : false));
        }

        public static function adjustURLRequest(_arg1:URLRequest, _arg2:String, _arg3:String):void
        {
            if (adjustURLRequestImpl != null)
            {
                adjustURLRequestImpl(_arg1, _arg2, _arg3);
            };
        }

        public static function adjustNetConnectionURL(_arg1:String, _arg2:String):String
        {
            if (adjustNetConnectionURLImpl != null)
            {
                return (adjustNetConnectionURLImpl(_arg1, _arg2));
            };
            return (null);
        }

        public static function monitorEvent(_arg1:Event, _arg2:String):void
        {
            if (monitorEventImpl != null)
            {
                monitorEventImpl(_arg1, _arg2);
            };
        }

        public static function monitorInvocation(_arg1:String, _arg2:Object, _arg3:Object):void
        {
            if (monitorInvocationImpl != null)
            {
                monitorInvocationImpl(_arg1, _arg2, _arg3);
            };
        }

        public static function monitorResult(_arg1:Object, _arg2:Object):void
        {
            if (monitorResultImpl != null)
            {
                monitorResultImpl(_arg1, _arg2);
            };
        }

        public static function monitorFault(_arg1:Object, _arg2:Object):void
        {
            if (monitorFaultImpl != null)
            {
                monitorFaultImpl(_arg1, _arg2);
            };
        }


    }
}//package mx.netmon
