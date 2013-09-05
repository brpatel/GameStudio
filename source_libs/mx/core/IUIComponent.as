//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import mx.managers.ISystemManager;
    import flash.display.DisplayObject;

    public interface IUIComponent extends IFlexDisplayObject 
    {

        function get baselinePosition():Number;
        function get document():Object;
        function set document(_arg1:Object):void;
        function get enabled():Boolean;
        function set enabled(_arg1:Boolean):void;
        function get explicitHeight():Number;
        function set explicitHeight(_arg1:Number):void;
        function get explicitMaxHeight():Number;
        function get explicitMaxWidth():Number;
        function get explicitMinHeight():Number;
        function get explicitMinWidth():Number;
        function get explicitWidth():Number;
        function set explicitWidth(_arg1:Number):void;
        function get focusPane():Sprite;
        function set focusPane(_arg1:Sprite):void;
        function get includeInLayout():Boolean;
        function set includeInLayout(_arg1:Boolean):void;
        function get isPopUp():Boolean;
        function set isPopUp(_arg1:Boolean):void;
        function get maxHeight():Number;
        function get maxWidth():Number;
        function get measuredMinHeight():Number;
        function set measuredMinHeight(_arg1:Number):void;
        function get measuredMinWidth():Number;
        function set measuredMinWidth(_arg1:Number):void;
        function get minHeight():Number;
        function get minWidth():Number;
        function get owner():DisplayObjectContainer;
        function set owner(_arg1:DisplayObjectContainer):void;
        function get percentHeight():Number;
        function set percentHeight(_arg1:Number):void;
        function get percentWidth():Number;
        function set percentWidth(_arg1:Number):void;
        function get systemManager():ISystemManager;
        function set systemManager(_arg1:ISystemManager):void;
        function get tweeningProperties():Array;
        function set tweeningProperties(_arg1:Array):void;
        function initialize():void;
        function parentChanged(_arg1:DisplayObjectContainer):void;
        function getExplicitOrMeasuredWidth():Number;
        function getExplicitOrMeasuredHeight():Number;
        function setVisible(_arg1:Boolean, _arg2:Boolean=false):void;
        function owns(_arg1:DisplayObject):Boolean;

    }
}//package mx.core
