//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.dragDrop
{
    import org.osflash.signals.ISignal;

    public interface IDropTarget 
    {

        function get onDragEnter():ISignal;
        function get onDragMove():ISignal;
        function get onDragExit():ISignal;
        function get onDragDrop():ISignal;

    }
}//package org.josht.starling.foxhole.dragDrop
