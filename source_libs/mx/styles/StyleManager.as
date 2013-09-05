//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    import mx.core.mx_internal;
    import flash.utils.Dictionary;
    import mx.core.Singleton;
    import mx.managers.SystemManagerGlobals;
    import mx.core.IFlexModuleFactory;
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import flash.events.IEventDispatcher;

    use namespace mx_internal;

    public class StyleManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const NOT_A_COLOR:uint = 0xFFFFFFFF;

        private static var implClassDependency:StyleManagerImpl;
        private static var _impl:IStyleManager2;
        private static var styleManagerDictionary:Dictionary;


        private static function get impl():IStyleManager2
        {
            if (!_impl)
            {
                _impl = IStyleManager2(Singleton.getInstance("mx.styles::IStyleManager2"));
            };
            return (_impl);
        }

        public static function getStyleManager(_arg1:IFlexModuleFactory):IStyleManager2
        {
            var _local2:IStyleManager2;
            var _local4:Object;
            if (!_arg1)
            {
                _arg1 = SystemManagerGlobals.topLevelSystemManagers[0];
            };
            if (!styleManagerDictionary)
            {
                styleManagerDictionary = new Dictionary(true);
            };
            var _local3:Dictionary = styleManagerDictionary[_arg1];
            if (_local3 == null)
            {
                _local2 = IStyleManager2(_arg1.getImplementation("mx.styles::IStyleManager2"));
                if (_local2 == null)
                {
                    _local2 = impl;
                };
                _local3 = new Dictionary(true);
                styleManagerDictionary[_arg1] = _local3;
                _local3[_local2] = 1;
            }
            else
            {
                for (_local4 in _local3)
                {
                    _local2 = (_local4 as IStyleManager2);
                    break;
                };
            };
            return (_local2);
        }

        mx_internal static function get stylesRoot():Object
        {
            return (impl.stylesRoot);
        }

        mx_internal static function set stylesRoot(_arg1:Object):void
        {
            impl.stylesRoot = _arg1;
        }

        mx_internal static function get inheritingStyles():Object
        {
            return (impl.inheritingStyles);
        }

        mx_internal static function set inheritingStyles(_arg1:Object):void
        {
            impl.inheritingStyles = _arg1;
        }

        mx_internal static function get typeHierarchyCache():Object
        {
            return (impl.typeHierarchyCache);
        }

        mx_internal static function set typeHierarchyCache(_arg1:Object):void
        {
            impl.typeHierarchyCache = _arg1;
        }

        mx_internal static function get typeSelectorCache():Object
        {
            return (impl.typeSelectorCache);
        }

        mx_internal static function set typeSelectorCache(_arg1:Object):void
        {
            impl.typeSelectorCache = _arg1;
        }

        mx_internal static function initProtoChainRoots():void
        {
            impl.initProtoChainRoots();
        }

        public static function get selectors():Array
        {
            return (impl.selectors);
        }

        public static function getStyleDeclaration(_arg1:String):CSSStyleDeclaration
        {
            return (impl.getStyleDeclaration(_arg1));
        }

        public static function setStyleDeclaration(_arg1:String, _arg2:CSSStyleDeclaration, _arg3:Boolean):void
        {
            impl.setStyleDeclaration(_arg1, _arg2, _arg3);
        }

        public static function clearStyleDeclaration(_arg1:String, _arg2:Boolean):void
        {
            impl.clearStyleDeclaration(_arg1, _arg2);
        }

        mx_internal static function styleDeclarationsChanged():void
        {
            impl.styleDeclarationsChanged();
        }

        public static function registerInheritingStyle(_arg1:String):void
        {
            impl.registerInheritingStyle(_arg1);
        }

        public static function isInheritingStyle(_arg1:String):Boolean
        {
            return (impl.isInheritingStyle(_arg1));
        }

        public static function isInheritingTextFormatStyle(_arg1:String):Boolean
        {
            return (impl.isInheritingTextFormatStyle(_arg1));
        }

        public static function registerSizeInvalidatingStyle(_arg1:String):void
        {
            impl.registerSizeInvalidatingStyle(_arg1);
        }

        public static function isSizeInvalidatingStyle(_arg1:String):Boolean
        {
            return (impl.isSizeInvalidatingStyle(_arg1));
        }

        public static function registerParentSizeInvalidatingStyle(_arg1:String):void
        {
            impl.registerParentSizeInvalidatingStyle(_arg1);
        }

        public static function isParentSizeInvalidatingStyle(_arg1:String):Boolean
        {
            return (impl.isParentSizeInvalidatingStyle(_arg1));
        }

        public static function registerParentDisplayListInvalidatingStyle(_arg1:String):void
        {
            impl.registerParentDisplayListInvalidatingStyle(_arg1);
        }

        public static function isParentDisplayListInvalidatingStyle(_arg1:String):Boolean
        {
            return (impl.isParentDisplayListInvalidatingStyle(_arg1));
        }

        public static function registerColorName(_arg1:String, _arg2:uint):void
        {
            impl.registerColorName(_arg1, _arg2);
        }

        public static function isColorName(_arg1:String):Boolean
        {
            return (impl.isColorName(_arg1));
        }

        public static function getColorName(_arg1:Object):uint
        {
            return (impl.getColorName(_arg1));
        }

        public static function getColorNames(_arg1:Array):void
        {
            impl.getColorNames(_arg1);
        }

        public static function isValidStyleValue(_arg1):Boolean
        {
            return (impl.isValidStyleValue(_arg1));
        }

        public static function loadStyleDeclarations(_arg1:String, _arg2:Boolean=true, _arg3:Boolean=false, _arg4:ApplicationDomain=null, _arg5:SecurityDomain=null):IEventDispatcher
        {
            return (impl.loadStyleDeclarations2(_arg1, _arg2, _arg4, _arg5));
        }

        public static function unloadStyleDeclarations(_arg1:String, _arg2:Boolean=true):void
        {
            impl.unloadStyleDeclarations(_arg1, _arg2);
        }


    }
}//package mx.styles
