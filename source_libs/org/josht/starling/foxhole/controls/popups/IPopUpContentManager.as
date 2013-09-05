//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.popups
{
    import org.osflash.signals.ISignal;
    import starling.display.DisplayObject;

    public interface IPopUpContentManager 
    {

        function get onClose():ISignal;
        function open(_arg1:DisplayObject, _arg2:DisplayObject):void;
        function close():void;
        function dispose():void;

    }
}//package org.josht.starling.foxhole.controls.popups
