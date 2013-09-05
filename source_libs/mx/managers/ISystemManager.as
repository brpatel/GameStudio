//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    import mx.core.IChildList;
    import flash.display.Sprite;
    import flash.display.LoaderInfo;
    import flash.geom.Rectangle;
    import flash.display.Stage;
    import flash.text.TextFormat;
    import flash.display.DisplayObject;
    import flash.events.*;
    import mx.core.*;

    public interface ISystemManager extends IEventDispatcher, IChildList, IFlexModuleFactory 
    {

        function get cursorChildren():IChildList;
        function get document():Object;
        function set document(_arg1:Object):void;
        function get embeddedFontList():Object;
        function get focusPane():Sprite;
        function set focusPane(_arg1:Sprite):void;
        function get isProxy():Boolean;
        function get loaderInfo():LoaderInfo;
        function get numModalWindows():int;
        function set numModalWindows(_arg1:int):void;
        function get popUpChildren():IChildList;
        function get rawChildren():IChildList;
        function get screen():Rectangle;
        function get stage():Stage;
        function get toolTipChildren():IChildList;
        function get topLevelSystemManager():ISystemManager;
        function getDefinitionByName(_arg1:String):Object;
        function isTopLevel():Boolean;
        function isFontFaceEmbedded(_arg1:TextFormat):Boolean;
        function isTopLevelRoot():Boolean;
        function getTopLevelRoot():DisplayObject;
        function getSandboxRoot():DisplayObject;
        function getVisibleApplicationRect(_arg1:Rectangle=null, _arg2:Boolean=false):Rectangle;
        function deployMouseShields(_arg1:Boolean):void;
        function invalidateParentSizeAndDisplayList():void;

    }
}//package mx.managers
