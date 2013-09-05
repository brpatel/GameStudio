//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    public interface IStyleClient extends ISimpleStyleClient 
    {

        function get className():String;
        function get inheritingStyles():Object;
        function set inheritingStyles(_arg1:Object):void;
        function get nonInheritingStyles():Object;
        function set nonInheritingStyles(_arg1:Object):void;
        function get styleDeclaration():CSSStyleDeclaration;
        function set styleDeclaration(_arg1:CSSStyleDeclaration):void;
        function getStyle(_arg1:String);
        function setStyle(_arg1:String, _arg2):void;
        function clearStyle(_arg1:String):void;
        function getClassStyleDeclarations():Array;
        function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void;
        function regenerateStyleCache(_arg1:Boolean):void;
        function registerEffects(_arg1:Array):void;

    }
}//package mx.styles
