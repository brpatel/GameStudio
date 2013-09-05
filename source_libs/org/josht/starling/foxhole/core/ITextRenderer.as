//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import flash.geom.Point;

    public interface ITextRenderer 
    {

        function get text():String;
        function set text(_arg1:String):void;
        function get baseline():Number;
        function measureText(_arg1:Point=null):Point;

    }
}//package org.josht.starling.foxhole.core
