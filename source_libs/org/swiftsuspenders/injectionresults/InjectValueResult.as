//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionresults
{
    import org.swiftsuspenders.Injector;

    public class InjectValueResult extends InjectionResult 
    {

        private var m_value:Object;

        public function InjectValueResult(_arg1:Object)
        {
            this.m_value = _arg1;
        }

        override public function getResponse(_arg1:Injector):Object
        {
            return (this.m_value);
        }


    }
}//package org.swiftsuspenders.injectionresults
