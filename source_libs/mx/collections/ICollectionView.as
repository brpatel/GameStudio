//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import flash.events.*;

    public interface ICollectionView extends IEventDispatcher 
    {

        function get length():int;
        function get filterFunction():Function;
        function set filterFunction(_arg1:Function):void;
        function get sort():ISort;
        function set sort(_arg1:ISort):void;
        function createCursor():IViewCursor;
        function contains(_arg1:Object):Boolean;
        function disableAutoUpdate():void;
        function enableAutoUpdate():void;
        function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void;
        function refresh():Boolean;

    }
}//package mx.collections
