//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.resources
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import flash.utils.Dictionary;
    import mx.managers.SystemManagerGlobals;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import flash.system.ApplicationDomain;
    import flash.events.FocusEvent;
    import mx.modules.IModuleInfo;
    import flash.utils.Timer;
    import mx.modules.ModuleManager;
    import mx.events.ModuleEvent;
    import mx.events.ResourceEvent;
    import flash.events.TimerEvent;
    import flash.system.SecurityDomain;
    import flash.events.IEventDispatcher;
    import mx.utils.StringUtil;
    import flash.system.Capabilities;

    use namespace mx_internal;

    public class ResourceManagerImpl extends EventDispatcher implements IResourceManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private static var instance:IResourceManager;

        private var ignoreMissingBundles:Boolean;
        private var bundleDictionary:Dictionary;
        private var localeMap:Object;
        private var resourceModules:Object;
        private var initializedForNonFrameworkApp:Boolean = false;
        private var _localeChain:Array;

        public function ResourceManagerImpl()
        {
            this.localeMap = {};
            this.resourceModules = {};
            super();
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 1)
                {
                    this.ignoreMissingBundles = true;
                    SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                };
            };
            var _local1:Object = SystemManagerGlobals.info;
            if (_local1)
            {
                this.processInfo(_local1, false);
            };
            this.ignoreMissingBundles = false;
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(FlexEvent.NEW_CHILD_APPLICATION, this.newChildApplicationHandler);
            };
        }

        public static function getInstance():IResourceManager
        {
            if (!instance)
            {
                instance = new (ResourceManagerImpl)();
            };
            return (instance);
        }


        public function get localeChain():Array
        {
            return (this._localeChain);
        }

        public function set localeChain(_arg1:Array):void
        {
            this._localeChain = _arg1;
            this.update();
        }

        public function installCompiledResourceBundles(_arg1:ApplicationDomain, _arg2:Array, _arg3:Array, _arg4:Boolean=false):Array
        {
            var _local10:String;
            var _local11:int;
            var _local12:String;
            var _local13:IResourceBundle;
            var _local5:Array = [];
            var _local6:uint;
            var _local7:int = ((_arg2) ? _arg2.length : 0);
            var _local8:int = ((_arg3) ? _arg3.length : 0);
            var _local9:int;
            while (_local9 < _local7)
            {
                _local10 = _arg2[_local9];
                _local11 = 0;
                while (_local11 < _local8)
                {
                    _local12 = _arg3[_local11];
                    _local13 = this.installCompiledResourceBundle(_arg1, _local10, _local12, _arg4);
                    if (_local13)
                    {
                        var _local14 = _local6++;
                        _local5[_local14] = _local13;
                    };
                    _local11++;
                };
                _local9++;
            };
            return (_local5);
        }

        private function installCompiledResourceBundle(_arg1:ApplicationDomain, _arg2:String, _arg3:String, _arg4:Boolean=false):IResourceBundle
        {
            var _local5:String;
            var _local6:String = _arg3;
            var _local7:int = _arg3.indexOf(":");
            if (_local7 != -1)
            {
                _local5 = _arg3.substring(0, _local7);
                _local6 = _arg3.substring((_local7 + 1));
            };
            var _local8:IResourceBundle = this.getResourceBundleInternal(_arg2, _arg3, _arg4);
            if (_local8)
            {
                return (_local8);
            };
            var _local9 = (((_arg2 + "$") + _local6) + "_properties");
            if (_local5 != null)
            {
                _local9 = ((_local5 + ".") + _local9);
            };
            var _local10:Class;
            if (_arg1.hasDefinition(_local9))
            {
                _local10 = Class(_arg1.getDefinition(_local9));
            };
            if (!_local10)
            {
                _local9 = _arg3;
                if (_arg1.hasDefinition(_local9))
                {
                    _local10 = Class(_arg1.getDefinition(_local9));
                };
            };
            if (!_local10)
            {
                _local9 = (_arg3 + "_properties");
                if (_arg1.hasDefinition(_local9))
                {
                    _local10 = Class(_arg1.getDefinition(_local9));
                };
            };
            if (!_local10)
            {
                if (this.ignoreMissingBundles)
                {
                    return (null);
                };
                throw (new Error((((("Could not find compiled resource bundle '" + _arg3) + "' for locale '") + _arg2) + "'.")));
            };
            _local8 = ResourceBundle(new (_local10)());
            ResourceBundle(_local8)._locale = _arg2;
            ResourceBundle(_local8)._bundleName = _arg3;
            this.addResourceBundle(_local8, _arg4);
            return (_local8);
        }

        private function newChildApplicationHandler(_arg1:FocusEvent):void
        {
            var _local2:Object = _arg1.relatedObject["info"]();
            var _local3:Boolean;
            if (("_resourceBundles" in _arg1.relatedObject))
            {
                _local3 = true;
            };
            var _local4:Array = this.processInfo(_local2, _local3);
            if (_local3)
            {
                _arg1.relatedObject["_resourceBundles"] = _local4;
            };
        }

        private function processInfo(_arg1:Object, _arg2:Boolean):Array
        {
            var _local3:Array = _arg1["compiledLocales"];
            ResourceBundle.locale = ((((!((_local3 == null))) && ((_local3.length > 0)))) ? _local3[0] : "en_US");
            var _local4:String = SystemManagerGlobals.parameters["localeChain"];
            if (((!((_local4 == null))) && (!((_local4 == "")))))
            {
                this.localeChain = _local4.split(",");
            };
            var _local5:ApplicationDomain = _arg1["currentDomain"];
            var _local6:Array = _arg1["compiledResourceBundleNames"];
            var _local7:Array = this.installCompiledResourceBundles(_local5, _local3, _local6, _arg2);
            if (!this.localeChain)
            {
                this.initializeLocaleChain(_local3);
            };
            return (_local7);
        }

        public function initializeLocaleChain(_arg1:Array):void
        {
            this.localeChain = LocaleSorter.sortLocalesByPreference(_arg1, this.getSystemPreferredLocales(), null, true);
        }

        public function loadResourceModule(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher
        {
            var moduleInfo:IModuleInfo;
            var resourceEventDispatcher:ResourceEventDispatcher;
            var timer:Timer;
            var timerHandler:Function;
            var url:String = _arg1;
            var updateFlag:Boolean = _arg2;
            var applicationDomain = _arg3;
            var securityDomain = _arg4;
            moduleInfo = ModuleManager.getModule(url);
            resourceEventDispatcher = new ResourceEventDispatcher(moduleInfo);
            var readyHandler:Function = function (_arg1:ModuleEvent):void
            {
                var _local2:* = _arg1.module.factory.create();
                resourceModules[_arg1.module.url].resourceModule = _local2;
                if (updateFlag)
                {
                    update();
                };
            };
            moduleInfo.addEventListener(ModuleEvent.READY, readyHandler, false, 0, true);
            var errorHandler:Function = function (_arg1:ModuleEvent):void
            {
                var _local3:ResourceEvent;
                var _local2:String = ("Unable to load resource module from " + url);
                if (resourceEventDispatcher.willTrigger(ResourceEvent.ERROR))
                {
                    _local3 = new ResourceEvent(ResourceEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
                    _local3.bytesLoaded = 0;
                    _local3.bytesTotal = 0;
                    _local3.errorText = _local2;
                    resourceEventDispatcher.dispatchEvent(_local3);
                }
                else
                {
                    throw (new Error(_local2));
                };
            };
            moduleInfo.addEventListener(ModuleEvent.ERROR, errorHandler, false, 0, true);
            this.resourceModules[url] = new ResourceModuleInfo(moduleInfo, readyHandler, errorHandler);
            timer = new Timer(0);
            timerHandler = function (_arg1:TimerEvent):void
            {
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                timer.stop();
                moduleInfo.load(applicationDomain, securityDomain);
            };
            timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            timer.start();
            return (resourceEventDispatcher);
        }

        public function unloadResourceModule(_arg1:String, _arg2:Boolean=true):void
        {
            var _local4:Array;
            var _local5:int;
            var _local6:int;
            var _local7:String;
            var _local8:String;
            var _local3:ResourceModuleInfo = this.resourceModules[_arg1];
            if (!_local3)
            {
                return;
            };
            if (_local3.resourceModule)
            {
                _local4 = _local3.resourceModule.resourceBundles;
                if (_local4)
                {
                    _local5 = _local4.length;
                    _local6 = 0;
                    while (_local6 < _local5)
                    {
                        _local7 = _local4[_local6].locale;
                        _local8 = _local4[_local6].bundleName;
                        this.removeResourceBundle(_local7, _local8);
                        _local6++;
                    };
                };
            };
            this.resourceModules[_arg1] = null;
            delete this.resourceModules[_arg1];
            _local3.moduleInfo.unload();
            if (_arg2)
            {
                this.update();
            };
        }

        public function addResourceBundle(_arg1:IResourceBundle, _arg2:Boolean=false):void
        {
            var _local3:String = _arg1.locale;
            var _local4:String = _arg1.bundleName;
            if (!this.localeMap[_local3])
            {
                this.localeMap[_local3] = {};
            };
            if (_arg2)
            {
                if (!this.bundleDictionary)
                {
                    this.bundleDictionary = new Dictionary(true);
                };
                this.bundleDictionary[_arg1] = (_local3 + _local4);
                this.localeMap[_local3][_local4] = this.bundleDictionary;
            }
            else
            {
                this.localeMap[_local3][_local4] = _arg1;
            };
        }

        public function getResourceBundle(_arg1:String, _arg2:String):IResourceBundle
        {
            return (this.getResourceBundleInternal(_arg1, _arg2, false));
        }

        private function getResourceBundleInternal(_arg1:String, _arg2:String, _arg3:Boolean):IResourceBundle
        {
            var _local7:String;
            var _local8:Object;
            var _local4:Object = this.localeMap[_arg1];
            if (!_local4)
            {
                return (null);
            };
            var _local5:IResourceBundle;
            var _local6:Object = _local4[_arg2];
            if ((_local6 is Dictionary))
            {
                if (_arg3)
                {
                    return (null);
                };
                _local7 = (_arg1 + _arg2);
                for (_local8 in _local6)
                {
                    if (_local6[_local8] == _local7)
                    {
                        _local5 = (_local8 as IResourceBundle);
                        break;
                    };
                };
            }
            else
            {
                _local5 = (_local6 as IResourceBundle);
            };
            return (_local5);
        }

        public function removeResourceBundle(_arg1:String, _arg2:String):void
        {
            delete this.localeMap[_arg1][_arg2];
            if (this.getBundleNamesForLocale(_arg1).length == 0)
            {
                delete this.localeMap[_arg1];
            };
        }

        public function removeResourceBundlesForLocale(_arg1:String):void
        {
            delete this.localeMap[_arg1];
        }

        public function update():void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function getLocales():Array
        {
            var _local2:String;
            var _local1:Array = [];
            for (_local2 in this.localeMap)
            {
                _local1.push(_local2);
            };
            return (_local1);
        }

        public function getPreferredLocaleChain():Array
        {
            return (LocaleSorter.sortLocalesByPreference(this.getLocales(), this.getSystemPreferredLocales(), null, true));
        }

        public function getBundleNamesForLocale(_arg1:String):Array
        {
            var _local3:String;
            var _local2:Array = [];
            for (_local3 in this.localeMap[_arg1])
            {
                _local2.push(_local3);
            };
            return (_local2);
        }

        public function findResourceBundleWithResource(_arg1:String, _arg2:String):IResourceBundle
        {
            var _local5:String;
            var _local6:Object;
            var _local7:Object;
            var _local8:IResourceBundle;
            var _local9:String;
            var _local10:Object;
            if (!this._localeChain)
            {
                return (null);
            };
            var _local3:int = this._localeChain.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = this.localeChain[_local4];
                _local6 = this.localeMap[_local5];
                if (_local6)
                {
                    _local7 = _local6[_arg1];
                    if (_local7)
                    {
                        _local8 = null;
                        if ((_local7 is Dictionary))
                        {
                            _local9 = (_local5 + _arg1);
                            for (_local10 in _local7)
                            {
                                if (_local7[_local10] == _local9)
                                {
                                    _local8 = (_local10 as IResourceBundle);
                                    break;
                                };
                            };
                        }
                        else
                        {
                            _local8 = (_local7 as IResourceBundle);
                        };
                        if (((_local8) && ((_arg2 in _local8.content))))
                        {
                            return (_local8);
                        };
                    };
                };
                _local4++;
            };
            return (null);
        }

        [Bindable("change")]
        public function getObject(_arg1:String, _arg2:String, _arg3:String=null)
        {
            var _local4:IResourceBundle = this.findBundle(_arg1, _arg2, _arg3);
            if (!_local4)
            {
                return (undefined);
            };
            return (_local4.content[_arg2]);
        }

        [Bindable("change")]
        public function getString(_arg1:String, _arg2:String, _arg3:Array=null, _arg4:String=null):String
        {
            var _local5:IResourceBundle = this.findBundle(_arg1, _arg2, _arg4);
            if (!_local5)
            {
                return (null);
            };
            var _local6:String = String(_local5.content[_arg2]);
            if (_arg3)
            {
                _local6 = StringUtil.substitute(_local6, _arg3);
            };
            return (_local6);
        }

        [Bindable("change")]
        public function getStringArray(_arg1:String, _arg2:String, _arg3:String=null):Array
        {
            var _local4:IResourceBundle = this.findBundle(_arg1, _arg2, _arg3);
            if (!_local4)
            {
                return (null);
            };
            var _local5:* = _local4.content[_arg2];
            var _local6:Array = String(_local5).split(",");
            var _local7:int = _local6.length;
            var _local8:int;
            while (_local8 < _local7)
            {
                _local6[_local8] = StringUtil.trim(_local6[_local8]);
                _local8++;
            };
            return (_local6);
        }

        [Bindable("change")]
        public function getNumber(_arg1:String, _arg2:String, _arg3:String=null):Number
        {
            var _local4:IResourceBundle = this.findBundle(_arg1, _arg2, _arg3);
            if (!_local4)
            {
                return (NaN);
            };
            var _local5:* = _local4.content[_arg2];
            return (Number(_local5));
        }

        [Bindable("change")]
        public function getInt(_arg1:String, _arg2:String, _arg3:String=null):int
        {
            var _local4:IResourceBundle = this.findBundle(_arg1, _arg2, _arg3);
            if (!_local4)
            {
                return (0);
            };
            var _local5:* = _local4.content[_arg2];
            return (int(_local5));
        }

        [Bindable("change")]
        public function getUint(_arg1:String, _arg2:String, _arg3:String=null):uint
        {
            var _local4:IResourceBundle = this.findBundle(_arg1, _arg2, _arg3);
            if (!_local4)
            {
                return (0);
            };
            var _local5:* = _local4.content[_arg2];
            return (uint(_local5));
        }

        [Bindable("change")]
        public function getBoolean(_arg1:String, _arg2:String, _arg3:String=null):Boolean
        {
            var _local4:IResourceBundle = this.findBundle(_arg1, _arg2, _arg3);
            if (!_local4)
            {
                return (false);
            };
            var _local5:* = _local4.content[_arg2];
            return ((String(_local5).toLowerCase() == "true"));
        }

        [Bindable("change")]
        public function getClass(_arg1:String, _arg2:String, _arg3:String=null):Class
        {
            var _local4:IResourceBundle = this.findBundle(_arg1, _arg2, _arg3);
            if (!_local4)
            {
                return (null);
            };
            var _local5:* = _local4.content[_arg2];
            return ((_local5 as Class));
        }

        private function findBundle(_arg1:String, _arg2:String, _arg3:String):IResourceBundle
        {
            this.supportNonFrameworkApps();
            return ((((_arg3)!=null) ? this.getResourceBundle(_arg3, _arg1) : this.findResourceBundleWithResource(_arg1, _arg2)));
        }

        private function supportNonFrameworkApps():void
        {
            if (this.initializedForNonFrameworkApp)
            {
                return;
            };
            this.initializedForNonFrameworkApp = true;
            if (this.getLocales().length > 0)
            {
                return;
            };
			
            var _local1:ApplicationDomain = ApplicationDomain.currentDomain;
			
            if (!_local1.hasDefinition("locale._CompiledResourceBundleInfo"))
            {
                return;
            };
            var _local2:Class = Class(_local1.getDefinition("locale._CompiledResourceBundleInfo"));
            var _local3:Array = _local2.compiledLocales;
            var _local4:Array = _local2.compiledResourceBundleNames;
            this.installCompiledResourceBundles(_local1, _local3, _local4);
            this.localeChain = _local3;
        }

        private function getSystemPreferredLocales():Array
        {
            var _local1:Array;
            if (Capabilities["languages"])
            {
                _local1 = Capabilities["languages"];
            }
            else
            {
                _local1 = [Capabilities.language];
            };
            return (_local1);
        }

        private function dumpResourceModule(_arg1):void
        {
            var _local2:ResourceBundle;
            var _local3:String;
            for each (_local2 in _arg1.resourceBundles)
            {
                trace(_local2.locale, _local2.bundleName);
                for (_local3 in _local2.content)
                {
                };
            };
        }

        private function enterFrameHandler(_arg1:Event):void
        {
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 2)
                {
                    SystemManagerGlobals.topLevelSystemManagers[0].removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                }
                else
                {
                    return;
                };
            };
            var _local2:Object = SystemManagerGlobals.info;
            if (_local2)
            {
                this.processInfo(_local2, false);
            };
        }


    }
}//package mx.resources

import mx.modules.IModuleInfo;
import mx.resources.IResourceModule;
import flash.events.EventDispatcher;
import mx.events.ModuleEvent;
import mx.events.ResourceEvent;

class ResourceModuleInfo 
{

    public var errorHandler:Function;
    public var moduleInfo:IModuleInfo;
    public var readyHandler:Function;
    public var resourceModule:IResourceModule;

    public function ResourceModuleInfo(_arg1:IModuleInfo, _arg2:Function, _arg3:Function)
    {
        this.moduleInfo = _arg1;
        this.readyHandler = _arg2;
        this.errorHandler = _arg3;
    }

}
class ResourceEventDispatcher extends EventDispatcher 
{

    public function ResourceEventDispatcher(_arg1:IModuleInfo)
    {
        _arg1.addEventListener(ModuleEvent.ERROR, this.moduleInfo_errorHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.PROGRESS, this.moduleInfo_progressHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.READY, this.moduleInfo_readyHandler, false, 0, true);
    }

    private function moduleInfo_errorHandler(_arg1:ModuleEvent):void
    {
        var _local2:ResourceEvent = new ResourceEvent(ResourceEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        _local2.errorText = _arg1.errorText;
        dispatchEvent(_local2);
    }

    private function moduleInfo_progressHandler(_arg1:ModuleEvent):void
    {
        var _local2:ResourceEvent = new ResourceEvent(ResourceEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        dispatchEvent(_local2);
    }

    private function moduleInfo_readyHandler(_arg1:ModuleEvent):void
    {
        var _local2:ResourceEvent = new ResourceEvent(ResourceEvent.COMPLETE);
        dispatchEvent(_local2);
    }


}
