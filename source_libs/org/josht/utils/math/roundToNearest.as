//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.utils.math
{
    public function roundToNearest(_arg1:Number, _arg2:Number=1):Number
    {
        if (_arg2 == 0)
        {
            return (_arg1);
        };
        var _local3:Number = (Math.round(roundToPrecision((_arg1 / _arg2), 10)) * _arg2);
        return (roundToPrecision(_local3, 10));
    }

}//package org.josht.utils.math
