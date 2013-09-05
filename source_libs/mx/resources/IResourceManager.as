//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.resources
{
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import flash.events.IEventDispatcher;
    import flash.events.*;

    public interface IResourceManager extends IEventDispatcher 
    {

        function get localeChain():Array;
        function set localeChain(_arg1:Array):void;
        function loadResourceModule(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher;
        function unloadResourceModule(_arg1:String, _arg2:Boolean=true):void;
        function addResourceBundle(_arg1:IResourceBundle, _arg2:Boolean=false):void;
        function removeResourceBundle(_arg1:String, _arg2:String):void;
        function removeResourceBundlesForLocale(_arg1:String):void;
        function update():void;
        function getLocales():Array;
        function getPreferredLocaleChain():Array;
        function getBundleNamesForLocale(_arg1:String):Array;
        function getResourceBundle(_arg1:String, _arg2:String):IResourceBundle;
        function findResourceBundleWithResource(_arg1:String, _arg2:String):IResourceBundle;
        [Bindable("change")]
        function getObject(_arg1:String, _arg2:String, _arg3:String=null);
        [Bindable("change")]
        function getString(_arg1:String, _arg2:String, _arg3:Array=null, _arg4:String=null):String;
        [Bindable("change")]
        function getStringArray(_arg1:String, _arg2:String, _arg3:String=null):Array;
        [Bindable("change")]
        function getNumber(_arg1:String, _arg2:String, _arg3:String=null):Number;
        [Bindable("change")]
        function getInt(_arg1:String, _arg2:String, _arg3:String=null):int;
        [Bindable("change")]
        function getUint(_arg1:String, _arg2:String, _arg3:String=null):uint;
        [Bindable("change")]
        function getBoolean(_arg1:String, _arg2:String, _arg3:String=null):Boolean;
        [Bindable("change")]
        function getClass(_arg1:String, _arg2:String, _arg3:String=null):Class;
        function installCompiledResourceBundles(_arg1:ApplicationDomain, _arg2:Array, _arg3:Array, _arg4:Boolean=false):Array;
        function initializeLocaleChain(_arg1:Array):void;

    }
}//package mx.resources
