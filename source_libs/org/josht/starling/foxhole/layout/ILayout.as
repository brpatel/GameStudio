//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.layout
{
    import org.osflash.signals.ISignal;
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;

    public interface ILayout 
    {

        function get onLayoutChange():ISignal;
        function layout(_arg1:Vector.<DisplayObject>, _arg2:ViewPortBounds=null, _arg3:LayoutBoundsResult=null):LayoutBoundsResult;

    }
}//package org.josht.starling.foxhole.layout
