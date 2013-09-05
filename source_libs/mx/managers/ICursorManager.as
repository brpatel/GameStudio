//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    public interface ICursorManager 
    {

        function get currentCursorID():int;
        function set currentCursorID(_arg1:int):void;
        function get currentCursorXOffset():Number;
        function set currentCursorXOffset(_arg1:Number):void;
        function get currentCursorYOffset():Number;
        function set currentCursorYOffset(_arg1:Number):void;
        function showCursor():void;
        function hideCursor():void;
        function setCursor(_arg1:Class, _arg2:int=2, _arg3:Number=0, _arg4:Number=0):int;
        function removeCursor(_arg1:int):void;
        function removeAllCursors():void;
        function setBusyCursor():void;
        function removeBusyCursor():void;
        function registerToUseBusyCursor(_arg1:Object):void;
        function unRegisterToUseBusyCursor(_arg1:Object):void;

    }
}//package mx.managers
