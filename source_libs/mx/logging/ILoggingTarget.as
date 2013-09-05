//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.logging
{
    public interface ILoggingTarget 
    {

        function get filters():Array;
        function set filters(_arg1:Array):void;
        function get level():int;
        function set level(_arg1:int):void;
        function addLogger(_arg1:ILogger):void;
        function removeLogger(_arg1:ILogger):void;

    }
}//package mx.logging
