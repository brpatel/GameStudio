//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionpoints
{
    import org.swiftsuspenders.Injector;
    import flash.utils.describeType;

    public class ConstructorInjectionPoint extends MethodInjectionPoint 
    {

        public function ConstructorInjectionPoint(_arg1:XML, _arg2:Class, _arg3:Injector=null)
        {
            var node:XML = _arg1;
            var clazz:Class = _arg2;
            var injector = _arg3;
            if (node.parameter.(@type == "*").length() == node.parameter.@type.length())
            {
                this.createDummyInstance(node, clazz);
            };
            super(node, injector);
        }

        override public function applyInjection(_arg1:Object, _arg2:Injector):Object
        {
            var _local3:Class = Class(_arg1);
            var _local4:Array = gatherParameterValues(_arg1, _arg2);
            switch (_local4.length)
            {
                case 0:
                    return (new (_local3)());
                case 1:
                    return (new _local3(_local4[0]));
                case 2:
                    return (new _local3(_local4[0], _local4[1]));
                case 3:
                    return (new _local3(_local4[0], _local4[1], _local4[2]));
                case 4:
                    return (new _local3(_local4[0], _local4[1], _local4[2], _local4[3]));
                case 5:
                    return (new _local3(_local4[0], _local4[1], _local4[2], _local4[3], _local4[4]));
                case 6:
                    return (new _local3(_local4[0], _local4[1], _local4[2], _local4[3], _local4[4], _local4[5]));
                case 7:
                    return (new _local3(_local4[0], _local4[1], _local4[2], _local4[3], _local4[4], _local4[5], _local4[6]));
                case 8:
                    return (new _local3(_local4[0], _local4[1], _local4[2], _local4[3], _local4[4], _local4[5], _local4[6], _local4[7]));
                case 9:
                    return (new _local3(_local4[0], _local4[1], _local4[2], _local4[3], _local4[4], _local4[5], _local4[6], _local4[7], _local4[8]));
                case 10:
                    return (new _local3(_local4[0], _local4[1], _local4[2], _local4[3], _local4[4], _local4[5], _local4[6], _local4[7], _local4[8], _local4[9]));
            };
            return (null);
        }

        override protected function initializeInjection(_arg1:XML):void
        {
            var nameArgs:XMLList;
            var node:XML = _arg1;
            nameArgs = node.parent().metadata.(@name == "Inject").arg.(@key == "name");
            methodName = "constructor";
            gatherParameters(node, nameArgs);
        }

        private function createDummyInstance(_arg1:XML, _arg2:Class):void
        {
            var constructorNode:XML = _arg1;
            var clazz:Class = _arg2;
            try
            {
                switch (constructorNode.children().length())
                {
                    case 0:
                        new (clazz)();
                        break;
                    case 1:
                        new clazz(null);
                        break;
                    case 2:
                        new clazz(null, null);
                        break;
                    case 3:
                        new clazz(null, null, null);
                        break;
                    case 4:
                        new clazz(null, null, null, null);
                        break;
                    case 5:
                        new clazz(null, null, null, null, null);
                        break;
                    case 6:
                        new clazz(null, null, null, null, null, null);
                        break;
                    case 7:
                        new clazz(null, null, null, null, null, null, null);
                        break;
                    case 8:
                        new clazz(null, null, null, null, null, null, null, null);
                        break;
                    case 9:
                        new clazz(null, null, null, null, null, null, null, null, null);
                        break;
                    case 10:
                        new clazz(null, null, null, null, null, null, null, null, null, null);
                        break;
                };
            }
            catch(error:Error)
            {
                trace(((((("Exception caught while trying to create dummy instance for constructor " + "injection. It's almost certainly ok to ignore this exception, but you ") + "might want to restructure your constructor to prevent errors from ") + "happening. See the SwiftSuspenders documentation for more details. ") + "The caught exception was:\n") + error));
            };
            constructorNode.setChildren(describeType(clazz).factory.constructor[0].children());
        }


    }
}//package org.swiftsuspenders.injectionpoints
