//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders
{
    import flash.utils.getDefinitionByName;
    import flash.utils.describeType;
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;
    import flash.utils.*;

    public class Reflector 
    {


        public function classExtendsOrImplements(_arg1:Object, _arg2:Class, _arg3:ApplicationDomain=null):Boolean
        {
            var actualClass:Class;
            var classOrClassName:Object = _arg1;
            var superclass:Class = _arg2;
            var application = _arg3;
            if ((classOrClassName is Class))
            {
                actualClass = Class(classOrClassName);
            }
            else
            {
                if ((classOrClassName is String))
                {
                    try
                    {
                        actualClass = Class(getDefinitionByName((classOrClassName as String)));
                    }
                    catch(e:Error)
                    {
                        throw (new Error(((((("The class name " + classOrClassName) + " is not valid because of ") + e) + "\n") + e.getStackTrace())));
                    };
                };
            };
            if (!actualClass)
            {
                throw (new Error(("The parameter classOrClassName must be a valid Class " + "instance or fully qualified class name.")));
            };
            if (actualClass == superclass)
            {
                return (true);
            };
            var factoryDescription:XML = describeType(actualClass).factory[0];
            return ((factoryDescription.children().(((name() == "implementsInterface")) || ((name() == "extendsClass"))).(attribute("type") == getQualifiedClassName(superclass)).length() > 0));
        }

        public function getClass(_arg1, _arg2:ApplicationDomain=null):Class
        {
            if ((_arg1 is Class))
            {
                return (_arg1);
            };
            return (getConstructor(_arg1));
        }

        public function getFQCN(_arg1, _arg2:Boolean=false):String
        {
            var _local3:String;
            var _local4:int;
            if ((_arg1 is String))
            {
                _local3 = _arg1;
                if (((!(_arg2)) && ((_local3.indexOf("::") == -1))))
                {
                    _local4 = _local3.lastIndexOf(".");
                    if (_local4 == -1)
                    {
                        return (_local3);
                    };
                    return (((_local3.substring(0, _local4) + "::") + _local3.substring((_local4 + 1))));
                };
            }
            else
            {
                _local3 = getQualifiedClassName(_arg1);
            };
            return (((_arg2) ? _local3.replace("::", ".") : _local3));
        }


    }
}//package org.swiftsuspenders
