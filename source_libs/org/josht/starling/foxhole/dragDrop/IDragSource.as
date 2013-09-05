//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.dragDrop
{
    import org.osflash.signals.ISignal;

    public interface IDragSource 
    {

        function get onDragStart():ISignal;
        function get onDragComplete():ISignal;

    }
}//package org.josht.starling.foxhole.dragDrop
