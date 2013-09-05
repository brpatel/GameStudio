//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionresults
{
    import org.swiftsuspenders.Injector;

    public class InjectClassResult extends InjectionResult 
    {

        private var m_responseType:Class;

        public function InjectClassResult(_arg1:Class)
        {
            this.m_responseType = _arg1;
        }

        override public function getResponse(_arg1:Injector):Object
        {
            return (_arg1.instantiate(this.m_responseType));
        }


    }
}//package org.swiftsuspenders.injectionresults
