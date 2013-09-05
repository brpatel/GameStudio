//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.core
{
    import starling.display.DisplayObjectContainer;

    public interface IStarlingViewMap 
    {

        function mapPackage(_arg1:String):void;
        function unmapPackage(_arg1:String):void;
        function hasPackage(_arg1:String):Boolean;
        function mapType(_arg1:Class):void;
        function unmapType(_arg1:Class):void;
        function hasType(_arg1:Class):Boolean;
        function get contextView():DisplayObjectContainer;
        function set contextView(_arg1:DisplayObjectContainer):void;
        function get enabled():Boolean;
        function set enabled(_arg1:Boolean):void;

    }
}//package org.robotlegs.core
