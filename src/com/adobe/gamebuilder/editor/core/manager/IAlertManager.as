
package com.adobe.gamebuilder.editor.core.manager
{
    public interface IAlertManager 
    {

        function show(_arg1:String, _arg2:String, _arg3:uint, _arg4:Function=null, _arg5:Object=null):void;
        function closeAlert():void;
        function set yesLabel(_arg1:String):void;
        function set noLabel(_arg1:String):void;
        function set okLabel(_arg1:String):void;
        function set cancelLabel(_arg1:String):void;

    }
}//package at.polypex.badplaner.core.manager
