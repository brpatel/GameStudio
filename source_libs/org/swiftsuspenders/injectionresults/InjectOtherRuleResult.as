//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionresults
{
    import org.swiftsuspenders.InjectionConfig;
    import org.swiftsuspenders.Injector;

    public class InjectOtherRuleResult extends InjectionResult 
    {

        private var m_rule:InjectionConfig;

        public function InjectOtherRuleResult(_arg1:InjectionConfig)
        {
            this.m_rule = _arg1;
        }

        override public function getResponse(_arg1:Injector):Object
        {
            return (this.m_rule.getResponse(_arg1));
        }


    }
}//package org.swiftsuspenders.injectionresults
