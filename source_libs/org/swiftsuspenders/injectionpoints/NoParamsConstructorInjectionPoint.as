//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionpoints
{
    import org.swiftsuspenders.Injector;

    public class NoParamsConstructorInjectionPoint extends InjectionPoint 
    {

        public function NoParamsConstructorInjectionPoint()
        {
            super(null, null);
        }

        override public function applyInjection(_arg1:Object, _arg2:Injector):Object
        {
            return (new ((_arg1 as Class))());
        }


    }
}//package org.swiftsuspenders.injectionpoints
