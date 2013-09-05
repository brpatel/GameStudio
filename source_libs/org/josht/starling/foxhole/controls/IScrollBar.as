//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.osflash.signals.ISignal;

    public interface IScrollBar 
    {

        function get minimum():Number;
        function set minimum(_arg1:Number):void;
        function get maximum():Number;
        function set maximum(_arg1:Number):void;
        function get value():Number;
        function set value(_arg1:Number):void;
        function get step():Number;
        function set step(_arg1:Number):void;
        function get page():Number;
        function set page(_arg1:Number):void;
        function get onChange():ISignal;

    }
}//package org.josht.starling.foxhole.controls
