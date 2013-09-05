//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.config
{
    import mx.core.mx_internal;
    import mx.utils.LoaderUtil;
    import flash.display.DisplayObject;

    use namespace mx_internal;

    public class LoaderConfig 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        mx_internal static var _parameters:Object;
        mx_internal static var _swfVersion:uint;
        mx_internal static var _url:String = null;


        public static function init(_arg1:DisplayObject):void
        {
            if (!_url)
            {
                _url = LoaderUtil.normalizeURL(_arg1.loaderInfo);
                _parameters = _arg1.loaderInfo.parameters;
                _swfVersion = _arg1.loaderInfo.swfVersion;
            };
        }

        public static function get parameters():Object
        {
            return (_parameters);
        }

        public static function get swfVersion():uint
        {
            return (_swfVersion);
        }

        public static function get url():String
        {
            return (_url);
        }


    }
}//package mx.messaging.config
