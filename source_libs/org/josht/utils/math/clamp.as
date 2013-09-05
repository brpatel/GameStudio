//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.utils.math
{
    public function clamp(_arg1:Number, _arg2:Number, _arg3:Number):Number
    {
        if (_arg2 > _arg3)
        {
            throw (new ArgumentError("minimum should be smaller than maximum."));
        };
        return (Math.min(_arg3, Math.max(_arg2, _arg1)));
    }

}//package org.josht.utils.math
