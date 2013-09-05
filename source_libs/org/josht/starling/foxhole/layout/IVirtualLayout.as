//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.layout
{
    import flash.geom.Point;

    public interface IVirtualLayout extends ILayout 
    {

        function get useVirtualLayout():Boolean;
        function set useVirtualLayout(_arg1:Boolean):void;
        function get typicalItemWidth():Number;
        function set typicalItemWidth(_arg1:Number):void;
        function get typicalItemHeight():Number;
        function set typicalItemHeight(_arg1:Number):void;
        function measureViewPort(_arg1:int, _arg2:ViewPortBounds=null, _arg3:Point=null):Point;
        function getMinimumItemIndexAtScrollPosition(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:int):int;
        function getMaximumItemIndexAtScrollPosition(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:int):int;
        function getScrollPositionForItemIndexAndBounds(_arg1:int, _arg2:Number, _arg3:Number, _arg4:Point=null):Point;

    }
}//package org.josht.starling.foxhole.layout
