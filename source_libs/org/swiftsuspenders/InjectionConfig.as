//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders
{
    import org.swiftsuspenders.injectionresults.InjectionResult;
    import flash.utils.getQualifiedClassName;

    public class InjectionConfig 
    {

        public var request:Class;
        public var injectionName:String;
        private var m_injector:Injector;
        private var m_result:InjectionResult;

        public function InjectionConfig(_arg1:Class, _arg2:String)
        {
            this.request = _arg1;
            this.injectionName = _arg2;
        }

        public function getResponse(_arg1:Injector):Object
        {
            if (this.m_result)
            {
                return (this.m_result.getResponse(((this.m_injector) || (_arg1))));
            };
            var _local2:InjectionConfig = ((this.m_injector) || (_arg1)).getAncestorMapping(this.request, this.injectionName);
            if (_local2)
            {
                return (_local2.getResponse(_arg1));
            };
            return (null);
        }

        public function hasResponse(_arg1:Injector):Boolean
        {
            if (this.m_result)
            {
                return (true);
            };
            var _local2:InjectionConfig = ((this.m_injector) || (_arg1)).getAncestorMapping(this.request, this.injectionName);
            return (!((_local2 == null)));
        }

        public function hasOwnResponse():Boolean
        {
            return (!((this.m_result == null)));
        }

        public function setResult(_arg1:InjectionResult):void
        {
            if (((!((this.m_result == null))) && (!((_arg1 == null)))))
            {
                trace(((((((('Warning: Injector already has a rule for type "' + getQualifiedClassName(this.request)) + '", named "') + this.injectionName) + '".\n ') + "If you have overwritten this mapping intentionally you can use ") + '"injector.unmap()" prior to your replacement mapping in order to ') + "avoid seeing this message."));
            };
            this.m_result = _arg1;
        }

        public function setInjector(_arg1:Injector):void
        {
            this.m_injector = _arg1;
        }


    }
}//package org.swiftsuspenders
