//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import org.osflash.signals.ISignal;

    public interface IToggle 
    {

        function get isSelected():Boolean;
        function set isSelected(_arg1:Boolean):void;
        function get onChange():ISignal;

    }
}//package org.josht.starling.foxhole.core
