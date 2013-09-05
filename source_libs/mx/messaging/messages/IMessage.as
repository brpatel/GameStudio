//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.messages
{
    public interface IMessage 
    {

        function get body():Object;
        function set body(_arg1:Object):void;
        function get clientId():String;
        function set clientId(_arg1:String):void;
        function get destination():String;
        function set destination(_arg1:String):void;
        function get headers():Object;
        function set headers(_arg1:Object):void;
        function get messageId():String;
        function set messageId(_arg1:String):void;
        function get timestamp():Number;
        function set timestamp(_arg1:Number):void;
        function get timeToLive():Number;
        function set timeToLive(_arg1:Number):void;
        function toString():String;

    }
}//package mx.messaging.messages
