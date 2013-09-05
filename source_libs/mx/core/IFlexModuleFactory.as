//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import flash.utils.Dictionary;
    import flash.display.LoaderInfo;
    import __AS3__.vec.Vector;

    public interface IFlexModuleFactory 
    {

        function get allowDomainsInNewRSLs():Boolean;
        function set allowDomainsInNewRSLs(_arg1:Boolean):void;
        function get allowInsecureDomainsInNewRSLs():Boolean;
        function set allowInsecureDomainsInNewRSLs(_arg1:Boolean):void;
        function get preloadedRSLs():Dictionary;
        function addPreloadedRSL(_arg1:LoaderInfo, _arg2:Vector.<RSLData>):void;
        function allowDomain(... _args):void;
        function allowInsecureDomain(... _args):void;
        function callInContext(_arg1:Function, _arg2:Object, _arg3:Array, _arg4:Boolean=true);
        function create(... _args):Object;
        function getImplementation(_arg1:String):Object;
        function info():Object;
        function registerImplementation(_arg1:String, _arg2:Object):void;

    }
}//package mx.core
