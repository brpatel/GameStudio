//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.preloaders
{
    import flash.display.Sprite;
    import flash.events.*;

    public interface IPreloaderDisplay extends IEventDispatcher 
    {

        function get backgroundAlpha():Number;
        function set backgroundAlpha(_arg1:Number):void;
        function get backgroundColor():uint;
        function set backgroundColor(_arg1:uint):void;
        function get backgroundImage():Object;
        function set backgroundImage(_arg1:Object):void;
        function get backgroundSize():String;
        function set backgroundSize(_arg1:String):void;
        function set preloader(_arg1:Sprite):void;
        function get stageHeight():Number;
        function set stageHeight(_arg1:Number):void;
        function get stageWidth():Number;
        function set stageWidth(_arg1:Number):void;
        function initialize():void;

    }
}//package mx.preloaders
