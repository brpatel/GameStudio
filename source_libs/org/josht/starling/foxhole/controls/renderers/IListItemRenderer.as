//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.renderers
{
    import org.josht.starling.foxhole.controls.List;
    import org.josht.starling.foxhole.core.*;

    public interface IListItemRenderer extends IToggle 
    {

        function get data():Object;
        function set data(_arg1:Object):void;
        function get index():int;
        function set index(_arg1:int):void;
        function get owner():List;
        function set owner(_arg1:List):void;

    }
}//package org.josht.starling.foxhole.controls.renderers
