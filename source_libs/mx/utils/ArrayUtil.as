//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class ArrayUtil 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";


        public static function toArray(_arg1:Object):Array
        {
            if (_arg1 == null)
            {
                return ([]);
            };
            if ((_arg1 is Array))
            {
                return ((_arg1 as Array));
            };
            return ([_arg1]);
        }

        public static function getItemIndex(_arg1:Object, _arg2:Array):int
        {
            var _local3:int = _arg2.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                if (_arg2[_local4] === _arg1)
                {
                    return (_local4);
                };
                _local4++;
            };
            return (-1);
        }


    }
}//package mx.utils
