//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.core
{
    import flash.system.ApplicationDomain;

    public interface IInjector 
    {

        function mapValue(_arg1:Class, _arg2:Object, _arg3:String="");
        function mapClass(_arg1:Class, _arg2:Class, _arg3:String="");
        function mapSingleton(_arg1:Class, _arg2:String="");
        function mapSingletonOf(_arg1:Class, _arg2:Class, _arg3:String="");
        function mapRule(_arg1:Class, _arg2, _arg3:String="");
        function injectInto(_arg1:Object):void;
        function instantiate(_arg1:Class);
        function getInstance(_arg1:Class, _arg2:String="");
        function createChild(_arg1:ApplicationDomain=null):IInjector;
        function unmap(_arg1:Class, _arg2:String=""):void;
        function hasMapping(_arg1:Class, _arg2:String=""):Boolean;
        function get applicationDomain():ApplicationDomain;
        function set applicationDomain(_arg1:ApplicationDomain):void;

    }
}//package org.robotlegs.core
