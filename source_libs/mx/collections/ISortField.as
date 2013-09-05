//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    public interface ISortField 
    {

        function get arraySortOnOptions():int;
        function get compareFunction():Function;
        function set compareFunction(_arg1:Function):void;
        function get descending():Boolean;
        function set descending(_arg1:Boolean):void;
        function get name():String;
        function set name(_arg1:String):void;
        function get numeric():Object;
        function set numeric(_arg1:Object):void;
        function get usingCustomCompareFunction():Boolean;
        function initializeDefaultCompareFunction(_arg1:Object):void;
        function reverse():void;

    }
}//package mx.collections
