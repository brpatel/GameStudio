//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.utils.math
{
    public function roundToPrecision(_arg1:Number, _arg2:int=0):Number
    {
        var _local3:Number = Math.pow(10, _arg2);
        return ((Math.round((_local3 * _arg1)) / _local3));
    }

}//package org.josht.utils.math
