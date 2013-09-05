package com.adobe.gamebuilder.editor.core
{
    import com.adobe.gamebuilder.editor.view.Container;

    public interface IGameEditor  
    {

        function barsToFront():void;
        function initApp():void;
        function switchViewMode(_arg1:String):void;
        function get container():Container;

    }
}
