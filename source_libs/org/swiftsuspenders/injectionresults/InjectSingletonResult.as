//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionresults
{
    import org.swiftsuspenders.Injector;

    public class InjectSingletonResult extends InjectionResult 
    {

        private var m_responseType:Class;
        private var m_response:Object;

        public function InjectSingletonResult(_arg1:Class)
        {
            this.m_responseType = _arg1;
        }

        override public function getResponse(_arg1:Injector):Object
        {
            return ((this.m_response = ((this.m_response) || (this.createResponse(_arg1)))));
        }

        private function createResponse(_arg1:Injector):Object
        {
            return (_arg1.instantiate(this.m_responseType));
        }


    }
}//package org.swiftsuspenders.injectionresults
