//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    import flash.display.DisplayObject;

    public interface ISystemManagerChildManager 
    {

        function addingChild(_arg1:DisplayObject):void;
        function childAdded(_arg1:DisplayObject):void;
        function childRemoved(_arg1:DisplayObject):void;
        function removingChild(_arg1:DisplayObject):void;
        function initializeTopLevelWindow(_arg1:Number, _arg2:Number):void;

    }
}//package mx.managers
