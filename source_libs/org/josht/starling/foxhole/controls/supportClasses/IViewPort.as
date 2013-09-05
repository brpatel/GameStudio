//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.supportClasses
{
    import org.osflash.signals.ISignal;

    public interface IViewPort 
    {

        function get visibleWidth():Number;
        function set visibleWidth(_arg1:Number):void;
        function get minVisibleWidth():Number;
        function set minVisibleWidth(_arg1:Number):void;
        function get maxVisibleWidth():Number;
        function set maxVisibleWidth(_arg1:Number):void;
        function get visibleHeight():Number;
        function set visibleHeight(_arg1:Number):void;
        function get minVisibleHeight():Number;
        function set minVisibleHeight(_arg1:Number):void;
        function get maxVisibleHeight():Number;
        function set maxVisibleHeight(_arg1:Number):void;
        function get onResize():ISignal;

    }
}//package org.josht.starling.foxhole.controls.supportClasses
