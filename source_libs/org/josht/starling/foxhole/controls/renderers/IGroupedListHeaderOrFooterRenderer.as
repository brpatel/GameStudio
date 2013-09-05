//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.renderers
{
    import org.josht.starling.foxhole.controls.GroupedList;

    public interface IGroupedListHeaderOrFooterRenderer 
    {

        function get data():Object;
        function set data(_arg1:Object):void;
        function get groupIndex():int;
        function set groupIndex(_arg1:int):void;
        function get owner():GroupedList;
        function set owner(_arg1:GroupedList):void;

    }
}//package org.josht.starling.foxhole.controls.renderers
