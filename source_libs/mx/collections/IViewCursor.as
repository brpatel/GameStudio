//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import flash.events.*;

    public interface IViewCursor extends IEventDispatcher 
    {

        [Bindable("cursorUpdate")]
        function get afterLast():Boolean;
        [Bindable("cursorUpdate")]
        function get beforeFirst():Boolean;
        [Bindable("cursorUpdate")]
        function get bookmark():CursorBookmark;
        [Bindable("cursorUpdate")]
        function get current():Object;
        function get view():ICollectionView;
        function findAny(_arg1:Object):Boolean;
        function findFirst(_arg1:Object):Boolean;
        function findLast(_arg1:Object):Boolean;
        function insert(_arg1:Object):void;
        function moveNext():Boolean;
        function movePrevious():Boolean;
        function remove():Object;
        function seek(_arg1:CursorBookmark, _arg2:int=0, _arg3:int=0):void;

    }
}//package mx.collections
