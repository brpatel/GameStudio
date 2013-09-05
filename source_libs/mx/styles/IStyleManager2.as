//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import flash.events.IEventDispatcher;

    public interface IStyleManager2 extends IStyleManager 
    {

        function get parent():IStyleManager2;
        function get qualifiedTypeSelectors():Boolean;
        function set qualifiedTypeSelectors(_arg1:Boolean):void;
        function get selectors():Array;
        function get typeHierarchyCache():Object;
        function set typeHierarchyCache(_arg1:Object):void;
        function getStyleDeclarations(_arg1:String):Object;
        function getMergedStyleDeclaration(_arg1:String):CSSStyleDeclaration;
        function hasPseudoCondition(_arg1:String):Boolean;
        function hasAdvancedSelectors():Boolean;
        function loadStyleDeclarations2(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher;
        function acceptMediaList(_arg1:String):Boolean;

    }
}//package mx.styles
