//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.core
{
    import flash.system.ApplicationDomain;

    public interface IReflector 
    {

        function classExtendsOrImplements(_arg1:Object, _arg2:Class, _arg3:ApplicationDomain=null):Boolean;
        function getClass(_arg1, _arg2:ApplicationDomain=null):Class;
        function getFQCN(_arg1, _arg2:Boolean=false):String;

    }
}//package org.robotlegs.core
