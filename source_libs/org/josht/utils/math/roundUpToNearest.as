//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.utils.math
{
    public function roundUpToNearest(_arg1:Number, _arg2:Number=1):Number
    {
        if (_arg2 == 0)
        {
            return (_arg1);
        };
        return ((Math.ceil(roundToPrecision((_arg1 / _arg2), 10)) * _arg2));
    }

}//package org.josht.utils.math
