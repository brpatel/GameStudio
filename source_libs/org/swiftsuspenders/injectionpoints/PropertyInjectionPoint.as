//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionpoints
{
    import org.swiftsuspenders.Injector;
    import org.swiftsuspenders.InjectionConfig;
    import org.swiftsuspenders.InjectorError;

    public class PropertyInjectionPoint extends InjectionPoint 
    {

        private var _propertyName:String;
        private var _propertyType:String;
        private var _injectionName:String;

        public function PropertyInjectionPoint(_arg1:XML, _arg2:Injector=null)
        {
            super(_arg1, null);
        }

        override public function applyInjection(_arg1:Object, _arg2:Injector):Object
        {
            var _local3:InjectionConfig = _arg2.getMapping(Class(_arg2.getApplicationDomain().getDefinition(this._propertyType)), this._injectionName);
            var _local4:Object = _local3.getResponse(_arg2);
            if (_local4 == null)
            {
                throw (new InjectorError((((((((('Injector is missing a rule to handle injection into property "' + this._propertyName) + '" of object "') + _arg1) + '". Target dependency: "') + this._propertyType) + '", named "') + this._injectionName) + '"')));
            };
            _arg1[this._propertyName] = _local4;
            return (_arg1);
        }

        override protected function initializeInjection(_arg1:XML):void
        {
            this._propertyType = _arg1.parent().@type.toString();
            this._propertyName = _arg1.parent().@name.toString();
            this._injectionName = _arg1.arg.attribute("value").toString();
        }


    }
}//package org.swiftsuspenders.injectionpoints
