//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import flash.events.*;

    public interface IList extends IEventDispatcher 
    {

        function get length():int;
        function addItem(_arg1:Object):void;
        function addItemAt(_arg1:Object, _arg2:int):void;
        function getItemAt(_arg1:int, _arg2:int=0):Object;
        function getItemIndex(_arg1:Object):int;
        function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void;
        function removeAll():void;
        function removeItemAt(_arg1:int):Object;
        function setItemAt(_arg1:Object, _arg2:int):Object;
        function toArray():Array;

    }
}//package mx.collections
