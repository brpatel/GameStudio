//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.mx_internal;
    import flash.utils.Dictionary;

    use namespace mx_internal;

    public class XMLNotifier 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private static var instance:XMLNotifier;

        public function XMLNotifier(_arg1:XMLNotifierSingleton)
        {
        }

        public static function getInstance():XMLNotifier
        {
            if (!instance)
            {
                instance = new XMLNotifier(new XMLNotifierSingleton());
            };
            return (instance);
        }

        mx_internal static function initializeXMLForNotification():Function
        {
            var notificationFunction:Function = function (_arg1:Object, _arg2:String, _arg3:Object, _arg4:Object, _arg5:Object):void
            {
                var _local8:Object;
                var _local7:Dictionary = arguments.callee.watched;
                if (_local7 != null)
                {
                    for (_local8 in _local7)
                    {
                        IXMLNotifiable(_local8).xmlNotification(_arg1, _arg2, _arg3, _arg4, _arg5);
                    };
                };
            };
            return (notificationFunction);
        }


        public function watchXML(_arg1:Object, _arg2:IXMLNotifiable, _arg3:String=null):void
        {
            var _local4:Object;
            var _local5:XML;
            var _local6:Object;
            var _local7:Dictionary;
            if ((((_arg1 is XMLList)) && ((_arg1.length() > 1))))
            {
                for each (_local4 in _arg1)
                {
                    this.watchXML(_local4, _arg2, _arg3);
                };
            }
            else
            {
                _local5 = XML(_arg1);
                _local6 = _local5.notification();
                if (!(_local6 is Function))
                {
                    _local6 = initializeXMLForNotification();
                    _local5.setNotification((_local6 as Function));
                    if (((_arg3) && ((_local6["uid"] == null))))
                    {
                        _local6["uid"] = _arg3;
                    };
                };
                if (_local6["watched"] == undefined)
                {
                    _local7 = new Dictionary(true);
                    _local6["watched"] = _local7;
                }
                else
                {
                    _local7 = _local6["watched"];
                };
                _local7[_arg2] = true;
            };
        }

        public function unwatchXML(_arg1:Object, _arg2:IXMLNotifiable):void
        {
            var _local3:Object;
            var _local4:XML;
            var _local5:Object;
            var _local6:Dictionary;
            if ((((_arg1 is XMLList)) && ((_arg1.length() > 1))))
            {
                for each (_local3 in _arg1)
                {
                    this.unwatchXML(_local3, _arg2);
                };
            }
            else
            {
                _local4 = XML(_arg1);
                _local5 = _local4.notification();
                if (!(_local5 is Function))
                {
                    return;
                };
                if (_local5["watched"] != undefined)
                {
                    _local6 = _local5["watched"];
                    delete _local6[_arg2];
                };
            };
        }


    }
}//package mx.utils

class XMLNotifierSingleton 
{


}
