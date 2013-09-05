//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders
{
    import flash.utils.Dictionary;
    import flash.system.ApplicationDomain;
    import org.swiftsuspenders.injectionresults.InjectValueResult;
    import org.swiftsuspenders.injectionresults.InjectClassResult;
    import org.swiftsuspenders.injectionresults.InjectSingletonResult;
    import org.swiftsuspenders.injectionresults.InjectOtherRuleResult;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.injectionpoints.InjectionPoint;
    import flash.utils.describeType;
    import org.swiftsuspenders.injectionpoints.ConstructorInjectionPoint;
    import org.swiftsuspenders.injectionpoints.NoParamsConstructorInjectionPoint;
    import org.swiftsuspenders.injectionpoints.PropertyInjectionPoint;
    import org.swiftsuspenders.injectionpoints.MethodInjectionPoint;
    import org.swiftsuspenders.injectionpoints.PostConstructInjectionPoint;
    import flash.utils.getDefinitionByName;

    public class Injector 
    {

        private static var INJECTION_POINTS_CACHE:Dictionary = new Dictionary(true);

        private var m_parentInjector:Injector;
        private var m_applicationDomain:ApplicationDomain;
        private var m_mappings:Dictionary;
        private var m_injecteeDescriptions:Dictionary;
        private var m_attendedToInjectees:Dictionary;
        private var m_xmlMetadata:XML;

        public function Injector(_arg1:XML=null)
        {
            this.m_mappings = new Dictionary();
            if (_arg1 != null)
            {
                this.m_injecteeDescriptions = new Dictionary(true);
            }
            else
            {
                this.m_injecteeDescriptions = INJECTION_POINTS_CACHE;
            };
            this.m_attendedToInjectees = new Dictionary(true);
            this.m_xmlMetadata = _arg1;
        }

        public static function purgeInjectionPointsCache():void
        {
            INJECTION_POINTS_CACHE = new Dictionary(true);
        }


        public function mapValue(_arg1:Class, _arg2:Object, _arg3:String="")
        {
            var _local4:InjectionConfig = this.getMapping(_arg1, _arg3);
            _local4.setResult(new InjectValueResult(_arg2));
            return (_local4);
        }

        public function mapClass(_arg1:Class, _arg2:Class, _arg3:String="")
        {
            var _local4:InjectionConfig = this.getMapping(_arg1, _arg3);
            _local4.setResult(new InjectClassResult(_arg2));
            return (_local4);
        }

        public function mapSingleton(_arg1:Class, _arg2:String="")
        {
            return (this.mapSingletonOf(_arg1, _arg1, _arg2));
        }

        public function mapSingletonOf(_arg1:Class, _arg2:Class, _arg3:String="")
        {
            var _local4:InjectionConfig = this.getMapping(_arg1, _arg3);
            _local4.setResult(new InjectSingletonResult(_arg2));
            return (_local4);
        }

        public function mapRule(_arg1:Class, _arg2, _arg3:String="")
        {
            var _local4:InjectionConfig = this.getMapping(_arg1, _arg3);
            _local4.setResult(new InjectOtherRuleResult(_arg2));
            return (_arg2);
        }

        public function getMapping(_arg1:Class, _arg2:String=""):InjectionConfig
        {
            var _local3:String = getQualifiedClassName(_arg1);
            var _local4:InjectionConfig = this.m_mappings[((_local3 + "#") + _arg2)];
            if (!_local4)
            {
                _local4 = (this.m_mappings[((_local3 + "#") + _arg2)] = new InjectionConfig(_arg1, _arg2));
            };
            return (_local4);
        }

        public function injectInto(_arg1:Object):void
        {
            var _local7:InjectionPoint;
            if (this.m_attendedToInjectees[_arg1])
            {
                return;
            };
            this.m_attendedToInjectees[_arg1] = true;
            var _local2:Class = getConstructor(_arg1);
            var _local3:InjecteeDescription = ((this.m_injecteeDescriptions[_local2]) || (this.getInjectionPoints(_local2)));
            var _local4:Array = _local3.injectionPoints;
            var _local5:int = _local4.length;
            var _local6:int;
            while (_local6 < _local5)
            {
                _local7 = _local4[_local6];
                _local7.applyInjection(_arg1, this);
                _local6++;
            };
        }

        public function instantiate(_arg1:Class)
        {
            var _local2:InjecteeDescription = this.m_injecteeDescriptions[_arg1];
            if (!_local2)
            {
                _local2 = this.getInjectionPoints(_arg1);
            };
            var _local3:InjectionPoint = _local2.ctor;
            var _local4:* = _local3.applyInjection(_arg1, this);
            this.injectInto(_local4);
            return (_local4);
        }

        public function unmap(_arg1:Class, _arg2:String=""):void
        {
            var _local3:InjectionConfig = this.getConfigurationForRequest(_arg1, _arg2);
            if (!_local3)
            {
                throw (new InjectorError(((((("Error while removing an injector mapping: " + "No mapping defined for class ") + getQualifiedClassName(_arg1)) + ', named "') + _arg2) + '"')));
            };
            _local3.setResult(null);
        }

        public function hasMapping(_arg1:Class, _arg2:String=""):Boolean
        {
            var _local3:InjectionConfig = this.getConfigurationForRequest(_arg1, _arg2);
            if (!_local3)
            {
                return (false);
            };
            return (_local3.hasResponse(this));
        }

        public function getInstance(_arg1:Class, _arg2:String="")
        {
            var _local3:InjectionConfig = this.getConfigurationForRequest(_arg1, _arg2);
            if (((!(_local3)) || (!(_local3.hasResponse(this)))))
            {
                throw (new InjectorError(((((("Error while getting mapping response: " + "No mapping defined for class ") + getQualifiedClassName(_arg1)) + ', named "') + _arg2) + '"')));
            };
            return (_local3.getResponse(this));
        }

        public function createChildInjector(_arg1:ApplicationDomain=null):Injector
        {
            var _local2:Injector = new Injector();
            _local2.setApplicationDomain(_arg1);
            _local2.setParentInjector(this);
            return (_local2);
        }

        public function setApplicationDomain(_arg1:ApplicationDomain):void
        {
            this.m_applicationDomain = _arg1;
        }

        public function getApplicationDomain():ApplicationDomain
        {
            return (((this.m_applicationDomain) ? this.m_applicationDomain : ApplicationDomain.currentDomain));
        }

        public function setParentInjector(_arg1:Injector):void
        {
            if (((this.m_parentInjector) && (!(_arg1))))
            {
                this.m_attendedToInjectees = new Dictionary(true);
            };
            this.m_parentInjector = _arg1;
            if (_arg1)
            {
                this.m_attendedToInjectees = _arg1.attendedToInjectees;
            };
        }

        public function getParentInjector():Injector
        {
            return (this.m_parentInjector);
        }

        function getAncestorMapping(_arg1:Class, _arg2:String=null):InjectionConfig
        {
            var _local4:InjectionConfig;
            var _local3:Injector = this.m_parentInjector;
            while (_local3)
            {
                _local4 = _local3.getConfigurationForRequest(_arg1, _arg2, false);
                if (((_local4) && (_local4.hasOwnResponse())))
                {
                    return (_local4);
                };
                _local3 = _local3.getParentInjector();
            };
            return (null);
        }

        function get attendedToInjectees():Dictionary
        {
            return (this.m_attendedToInjectees);
        }

        private function getInjectionPoints(_arg1:Class):InjecteeDescription
        {
            var node:XML;
            var ctorInjectionPoint:InjectionPoint;
            var injectionPoint:InjectionPoint;
            var postConstructMethodPoints:Array;
            var clazz:Class = _arg1;
            var description:XML = describeType(clazz);
            if (((!((description.@name == "Object"))) && ((description.factory.extendsClass.length() == 0))))
            {
                throw (new InjectorError("Interfaces can't be used as instantiatable classes."));
            };
            var injectionPoints:Array = [];
            if (this.m_xmlMetadata)
            {
                this.createInjectionPointsFromConfigXML(description);
                this.addParentInjectionPoints(description, injectionPoints);
            };
            node = description.factory.constructor[0];
            if (node)
            {
                ctorInjectionPoint = new ConstructorInjectionPoint(node, clazz, this);
            }
            else
            {
                ctorInjectionPoint = new NoParamsConstructorInjectionPoint();
            };
            for each (node in description.factory.*.(((name() == "variable")) || ((name() == "accessor"))).metadata.(@name == "Inject"))
            {
                injectionPoint = new PropertyInjectionPoint(node);
                injectionPoints.push(injectionPoint);
            };
            for each (node in description.factory.method.metadata.(@name == "Inject"))
            {
                injectionPoint = new MethodInjectionPoint(node, this);
                injectionPoints.push(injectionPoint);
            };
            postConstructMethodPoints = [];
            for each (node in description.factory.method.metadata.(@name == "PostConstruct"))
            {
                injectionPoint = new PostConstructInjectionPoint(node, this);
                postConstructMethodPoints.push(injectionPoint);
            };
            if (postConstructMethodPoints.length > 0)
            {
                postConstructMethodPoints.sortOn("order", Array.NUMERIC);
                injectionPoints.push.apply(injectionPoints, postConstructMethodPoints);
            };
            var injecteeDescription:InjecteeDescription = new InjecteeDescription(ctorInjectionPoint, injectionPoints);
            this.m_injecteeDescriptions[clazz] = injecteeDescription;
            return (injecteeDescription);
        }

        private function getConfigurationForRequest(_arg1:Class, _arg2:String, _arg3:Boolean=true):InjectionConfig
        {
            var _local4:String = getQualifiedClassName(_arg1);
            var _local5:InjectionConfig = this.m_mappings[((_local4 + "#") + _arg2)];
            if (((((((!(_local5)) && (_arg3))) && (this.m_parentInjector))) && (this.m_parentInjector.hasMapping(_arg1, _arg2))))
            {
                _local5 = this.getAncestorMapping(_arg1, _arg2);
            };
            return (_local5);
        }

        private function createInjectionPointsFromConfigXML(_arg1:XML):void
        {
            var node:XML;
            var className:String;
            var metaNode:XML;
            var typeNode:XML;
            var arg:XML;
            var description:XML = _arg1;
            for each (node in description..metadata.(((@name == "Inject")) || ((@name == "PostConstruct"))))
            {
                delete node.parent().metadata.(((@name == "Inject")) || ((@name == "PostConstruct")))[0];
            };
            className = description.factory.@type;
            for each (node in this.m_xmlMetadata.type.(@name == className).children())
            {
                metaNode = <metadata/>
                ;
                if (node.name() == "postconstruct")
                {
                    metaNode.@name = "PostConstruct";
                    if (node.@order.length())
                    {
                        metaNode.appendChild(new XML((("<arg key='order' value=\"" + node.@order) + '"/>')));
                    };
                }
                else
                {
                    metaNode.@name = "Inject";
                    if (node.@injectionname.length())
                    {
                        metaNode.appendChild(new XML((("<arg key='name' value=\"" + node.@injectionname) + '"/>')));
                    };
                    for each (arg in node.arg)
                    {
                        metaNode.appendChild(new XML((("<arg key='name' value=\"" + arg.@injectionname) + '"/>')));
                    };
                };
                if (node.name() == "constructor")
                {
                    typeNode = description.factory[0];
                }
                else
                {
                    typeNode = description.factory.*.(attribute("name") == node.@name)[0];
                    if (!typeNode)
                    {
                        throw (new InjectorError((((('Error in XML configuration: Class "' + className) + "\" doesn't contain the instance member \"") + node.@name) + '"')));
                    };
                };
                typeNode.appendChild(metaNode);
            };
        }

        private function addParentInjectionPoints(_arg1:XML, _arg2:Array):void
        {
            var _local3:String = _arg1.factory.extendsClass.@type[0];
            if (!_local3)
            {
                return;
            };
            var _local4:Class = Class(getDefinitionByName(_local3));
            var _local5:InjecteeDescription = ((this.m_injecteeDescriptions[_local4]) || (this.getInjectionPoints(_local4)));
            var _local6:Array = _local5.injectionPoints;
            _arg2.push.apply(_arg2, _local6);
        }


    }
}//package org.swiftsuspenders

import org.swiftsuspenders.injectionpoints.InjectionPoint;

final class InjecteeDescription 
{

    public var ctor:InjectionPoint;
    public var injectionPoints:Array;

    public function InjecteeDescription(_arg1:InjectionPoint, _arg2:Array)
    {
        this.ctor = _arg1;
        this.injectionPoints = _arg2;
    }

}
