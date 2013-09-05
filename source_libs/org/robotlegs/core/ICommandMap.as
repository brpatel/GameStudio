//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.core
{
    public interface ICommandMap 
    {

        function detain(_arg1:Object):void;
        function release(_arg1:Object):void;
        function execute(_arg1:Class, _arg2:Object=null, _arg3:Class=null, _arg4:String=""):void;
        function mapEvent(_arg1:String, _arg2:Class, _arg3:Class=null, _arg4:Boolean=false):void;
        function unmapEvent(_arg1:String, _arg2:Class, _arg3:Class=null):void;
        function unmapEvents():void;
        function hasEventCommand(_arg1:String, _arg2:Class, _arg3:Class=null):Boolean;

    }
}//package org.robotlegs.core
