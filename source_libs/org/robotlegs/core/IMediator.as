﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.core
{
    public interface IMediator 
    {

        function preRegister():void;
        function onRegister():void;
        function preRemove():void;
        function onRemove():void;
        function getViewComponent():Object;
        function setViewComponent(_arg1:Object):void;

    }
}//package org.robotlegs.core
