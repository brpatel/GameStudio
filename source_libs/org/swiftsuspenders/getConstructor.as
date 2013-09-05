//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders
{
    import flash.utils.Proxy;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    import org.swiftsuspenders.*;

    function getConstructor(_arg1:Object):Class
    {
        var _local2:String;
        if ((((((((_arg1 is Proxy)) || ((_arg1 is Number)))) || ((_arg1 is XML)))) || ((_arg1 is XMLList))))
        {
            _local2 = getQualifiedClassName(_arg1);
            return (Class(getDefinitionByName(_local2)));
        };
        return (_arg1.constructor);
    }

}//package org.swiftsuspenders
