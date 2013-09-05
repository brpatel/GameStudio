//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import flash.display.DisplayObject;
    import flash.geom.Point;

    public interface IChildList 
    {

        function get numChildren():int;
        function addChild(_arg1:DisplayObject):DisplayObject;
        function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject;
        function removeChild(_arg1:DisplayObject):DisplayObject;
        function removeChildAt(_arg1:int):DisplayObject;
        function getChildAt(_arg1:int):DisplayObject;
        function getChildByName(_arg1:String):DisplayObject;
        function getChildIndex(_arg1:DisplayObject):int;
        function setChildIndex(_arg1:DisplayObject, _arg2:int):void;
        function getObjectsUnderPoint(_arg1:Point):Array;
        function contains(_arg1:DisplayObject):Boolean;

    }
}//package mx.core
