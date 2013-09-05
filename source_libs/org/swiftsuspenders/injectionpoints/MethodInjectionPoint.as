//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionpoints
{
    import org.swiftsuspenders.Injector;
    import org.swiftsuspenders.InjectorError;
    import org.swiftsuspenders.InjectionConfig;
    import flash.utils.getQualifiedClassName;

    public class MethodInjectionPoint extends InjectionPoint 
    {

        protected var methodName:String;
        protected var _parameterInjectionConfigs:Array;
        protected var requiredParameters:int = 0;

        public function MethodInjectionPoint(_arg1:XML, _arg2:Injector=null)
        {
            super(_arg1, _arg2);
        }

        override public function applyInjection(_arg1:Object, _arg2:Injector):Object
        {
            var _local3:Array = this.gatherParameterValues(_arg1, _arg2);
            var _local4:Function = _arg1[this.methodName];
            _local4.apply(_arg1, _local3);
            return (_arg1);
        }

        override protected function initializeInjection(_arg1:XML):void
        {
            var nameArgs:XMLList;
            var methodNode:XML;
            var node:XML = _arg1;
            nameArgs = node.arg.(@key == "name");
            methodNode = node.parent();
            this.methodName = methodNode.@name.toString();
            this.gatherParameters(methodNode, nameArgs);
        }

        protected function gatherParameters(_arg1:XML, _arg2:XMLList):void
        {
            var _local4:XML;
            var _local5:String;
            var _local6:String;
            this._parameterInjectionConfigs = [];
            var _local3:int;
            for each (_local4 in _arg1.parameter)
            {
                _local5 = "";
                if (_arg2[_local3])
                {
                    _local5 = _arg2[_local3].@value.toString();
                };
                _local6 = _local4.@type.toString();
                if (_local6 == "*")
                {
                    if (_local4.@optional.toString() == "false")
                    {
                        throw (new InjectorError(("Error in method definition of injectee. " + "Required parameters can't have type \"*\".")));
                    };
                    _local6 = null;
                };
                this._parameterInjectionConfigs.push(new ParameterInjectionConfig(_local6, _local5));
                if (_local4.@optional.toString() == "false")
                {
                    this.requiredParameters++;
                };
                _local3++;
            };
        }

        protected function gatherParameterValues(_arg1:Object, _arg2:Injector):Array
        {
            var _local6:ParameterInjectionConfig;
            var _local7:InjectionConfig;
            var _local8:Object;
            var _local3:Array = [];
            var _local4:int = this._parameterInjectionConfigs.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                _local6 = this._parameterInjectionConfigs[_local5];
                _local7 = _arg2.getMapping(Class(_arg2.getApplicationDomain().getDefinition(_local6.typeName)), _local6.injectionName);
                _local8 = _local7.getResponse(_arg2);
                if (_local8 == null)
                {
                    if (_local5 >= this.requiredParameters) break;
                    throw (new InjectorError(((((((("Injector is missing a rule to handle injection into target " + _arg1) + ". Target dependency: ") + getQualifiedClassName(_local7.request)) + ", method: ") + this.methodName) + ", parameter: ") + (_local5 + 1))));
                };
                _local3[_local5] = _local8;
                _local5++;
            };
            return (_local3);
        }


    }
}//package org.swiftsuspenders.injectionpoints

final class ParameterInjectionConfig 
{

    public var typeName:String;
    public var injectionName:String;

    public function ParameterInjectionConfig(_arg1:String, _arg2:String)
    {
        this.typeName = _arg1;
        this.injectionName = _arg2;
    }

}
