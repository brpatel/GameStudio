//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import flash.events.IEventDispatcher;

    public interface IStyleManager 
    {

        function get inheritingStyles():Object;
        function set inheritingStyles(_arg1:Object):void;
        function get stylesRoot():Object;
        function set stylesRoot(_arg1:Object):void;
        function get typeSelectorCache():Object;
        function set typeSelectorCache(_arg1:Object):void;
        function getStyleDeclaration(_arg1:String):CSSStyleDeclaration;
        function setStyleDeclaration(_arg1:String, _arg2:CSSStyleDeclaration, _arg3:Boolean):void;
        function clearStyleDeclaration(_arg1:String, _arg2:Boolean):void;
        function registerInheritingStyle(_arg1:String):void;
        function isInheritingStyle(_arg1:String):Boolean;
        function isInheritingTextFormatStyle(_arg1:String):Boolean;
        function registerSizeInvalidatingStyle(_arg1:String):void;
        function isSizeInvalidatingStyle(_arg1:String):Boolean;
        function registerParentSizeInvalidatingStyle(_arg1:String):void;
        function isParentSizeInvalidatingStyle(_arg1:String):Boolean;
        function registerParentDisplayListInvalidatingStyle(_arg1:String):void;
        function isParentDisplayListInvalidatingStyle(_arg1:String):Boolean;
        function registerColorName(_arg1:String, _arg2:uint):void;
        function isColorName(_arg1:String):Boolean;
        function getColorName(_arg1:Object):uint;
        function getColorNames(_arg1:Array):void;
        function isValidStyleValue(_arg1):Boolean;
        function loadStyleDeclarations(_arg1:String, _arg2:Boolean=true, _arg3:Boolean=false, _arg4:ApplicationDomain=null, _arg5:SecurityDomain=null):IEventDispatcher;
        function unloadStyleDeclarations(_arg1:String, _arg2:Boolean=true):void;
        function initProtoChainRoots():void;
        function styleDeclarationsChanged():void;

    }
}//package mx.styles
