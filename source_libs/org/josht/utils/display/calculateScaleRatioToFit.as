//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.utils.display
{
    public function calculateScaleRatioToFit(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
    {
        var _local5:Number = (_arg3 / _arg1);
        var _local6:Number = (_arg4 / _arg2);
        return (Math.min(_local5, _local6));
    }

}//package org.josht.utils.display
