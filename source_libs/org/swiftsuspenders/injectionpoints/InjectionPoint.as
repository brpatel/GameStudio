//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionpoints
{
    import org.swiftsuspenders.Injector;

    public class InjectionPoint 
    {

        public function InjectionPoint(_arg1:XML, _arg2:Injector)
        {
            this.initializeInjection(_arg1);
        }

        public function applyInjection(_arg1:Object, _arg2:Injector):Object
        {
            return (_arg1);
        }

        protected function initializeInjection(_arg1:XML):void
        {
        }


    }
}//package org.swiftsuspenders.injectionpoints
