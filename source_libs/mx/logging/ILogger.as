//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.logging
{
    import flash.events.*;

    public interface ILogger extends IEventDispatcher 
    {

        function get category():String;
        function log(_arg1:int, _arg2:String, ... _args):void;
        function debug(_arg1:String, ... _args):void;
        function error(_arg1:String, ... _args):void;
        function fatal(_arg1:String, ... _args):void;
        function info(_arg1:String, ... _args):void;
        function warn(_arg1:String, ... _args):void;

    }
}//package mx.logging
