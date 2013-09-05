//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.modules
{
    import mx.core.mx_internal;
    import mx.core.IFlexModuleFactory;

    use namespace mx_internal;

    public class ModuleManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";


        public static function getModule(_arg1:String):IModuleInfo
        {
            return (getSingleton().getModule(_arg1));
        }

        public static function getAssociatedFactory(_arg1:Object):IFlexModuleFactory
        {
            return (getSingleton().getAssociatedFactory(_arg1));
        }

        private static function getSingleton():Object
        {
            if (!ModuleManagerGlobals.managerSingleton)
            {
                ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl();
            };
            return (ModuleManagerGlobals.managerSingleton);
        }


    }
}//package mx.modules

import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;
import mx.core.IFlexModuleFactory;
import mx.modules.IModuleInfo;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import mx.events.ModuleEvent;
import mx.events.Request;
import flash.events.ErrorEvent;
import mx.modules.*;

class ModuleManagerImpl extends EventDispatcher 
{

    private var moduleDictionary:Dictionary;

    public function ModuleManagerImpl()
    {
        this.moduleDictionary = new Dictionary(true);
        super();
    }

    public function getAssociatedFactory(_arg1:Object):IFlexModuleFactory
    {
        var _local3:Object;
        var _local4:ModuleInfo;
        var _local5:ApplicationDomain;
        var _local6:Class;
        var _local2:String = getQualifiedClassName(_arg1);
        for (_local3 in this.moduleDictionary)
        {
            _local4 = (_local3 as ModuleInfo);
            if (_local4.ready)
            {
                _local5 = _local4.applicationDomain;
                if (_local5.hasDefinition(_local2))
                {
                    _local6 = Class(_local5.getDefinition(_local2));
                    if (((_local6) && ((_arg1 is _local6))))
                    {
                        return (_local4.factory);
                    };
                };
            };
        };
        return (null);
    }

    public function getModule(_arg1:String):IModuleInfo
    {
        var _local3:Object;
        var _local4:ModuleInfo;
        var _local2:ModuleInfo;
        for (_local3 in this.moduleDictionary)
        {
            _local4 = (_local3 as ModuleInfo);
            if (this.moduleDictionary[_local4] == _arg1)
            {
                _local2 = _local4;
                break;
            };
        };
        if (!_local2)
        {
            _local2 = new ModuleInfo(_arg1);
            this.moduleDictionary[_local2] = _arg1;
        };
        return (new ModuleInfoProxy(_local2));
    }


}
class ModuleInfo extends EventDispatcher 
{

    private var factoryInfo:FactoryInfo;
    private var loader:Loader;
    private var numReferences:int = 0;
    private var parentModuleFactory:IFlexModuleFactory;
    private var _error:Boolean = false;
    private var _loaded:Boolean = false;
    private var _ready:Boolean = false;
    private var _setup:Boolean = false;
    private var _url:String;

    public function ModuleInfo(_arg1:String)
    {
        this._url = _arg1;
    }

    public function get applicationDomain():ApplicationDomain
    {
        return (((this.factoryInfo) ? this.factoryInfo.applicationDomain : null));
    }

    public function get error():Boolean
    {
        return (this._error);
    }

    public function get factory():IFlexModuleFactory
    {
        return (((this.factoryInfo) ? this.factoryInfo.factory : null));
    }

    public function get loaded():Boolean
    {
        return (this._loaded);
    }

    public function get ready():Boolean
    {
        return (this._ready);
    }

    public function get setup():Boolean
    {
        return (this._setup);
    }

    public function get size():int
    {
        return (((this.factoryInfo) ? this.factoryInfo.bytesTotal : 0));
    }

    public function get url():String
    {
        return (this._url);
    }

    public function load(_arg1:ApplicationDomain=null, _arg2:SecurityDomain=null, _arg3:ByteArray=null, _arg4:IFlexModuleFactory=null):void
    {
        if (this._loaded)
        {
            return;
        };
        this._loaded = true;
        this.parentModuleFactory = _arg4;
        if (_arg3)
        {
            this.loadBytes(_arg1, _arg3);
            return;
        };
        if (this._url.indexOf("published://") == 0)
        {
            return;
        };
        var _local5:URLRequest = new URLRequest(this._url);
        var _local6:LoaderContext = new LoaderContext();
        _local6.applicationDomain = ((_arg1) ? _arg1 : new ApplicationDomain(ApplicationDomain.currentDomain));
        if (((!((_arg2 == null))) && ((Security.sandboxType == Security.REMOTE))))
        {
            _local6.securityDomain = _arg2;
        };
        this.loader = new Loader();
        this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initHandler);
        this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
        this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
        this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
        this.loader.load(_local5, _local6);
    }

    private function loadBytes(_arg1:ApplicationDomain, _arg2:ByteArray):void
    {
        var _local3:LoaderContext = new LoaderContext();
        _local3.applicationDomain = ((_arg1) ? _arg1 : new ApplicationDomain(ApplicationDomain.currentDomain));
        if (("allowLoadBytesCodeExecution" in _local3))
        {
            _local3["allowLoadBytesCodeExecution"] = true;
        };
        this.loader = new Loader();
        this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initHandler);
        this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
        this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
        this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
        this.loader.loadBytes(_arg2, _local3);
    }

    public function resurrect():void
    {
        if (!this._ready)
        {
            return;
        };
        if (!this.factoryInfo)
        {
            if (this._loaded)
            {
                dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
            };
            this.loader = null;
            this._loaded = false;
            this._setup = false;
            this._ready = false;
            this._error = false;
        };
    }

    public function release():void
    {
        if (!this._ready)
        {
            this.unload();
        };
    }

    private function clearLoader():void
    {
        if (this.loader)
        {
            if (this.loader.contentLoaderInfo)
            {
                this.loader.contentLoaderInfo.removeEventListener(Event.INIT, this.initHandler);
                this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.completeHandler);
                this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
                this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
                this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            };
            try
            {
                if (this.loader.content)
                {
                    this.loader.content.removeEventListener("ready", this.readyHandler);
                    this.loader.content.removeEventListener("error", this.moduleErrorHandler);
                };
            }
            catch(error:Error)
            {
            };
            if (this._loaded)
            {
                try
                {
                    this.loader.close();
                }
                catch(error:Error)
                {
                };
            };
            try
            {
                this.loader.unload();
            }
            catch(error:Error)
            {
            };
            this.loader = null;
        };
    }

    public function unload():void
    {
        this.clearLoader();
        if (this._loaded)
        {
            dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
        };
        this.factoryInfo = null;
        this.parentModuleFactory = null;
        this._loaded = false;
        this._setup = false;
        this._ready = false;
        this._error = false;
    }

    public function publish(_arg1:IFlexModuleFactory):void
    {
        if (this.factoryInfo)
        {
            return;
        };
        if (this._url.indexOf("published://") != 0)
        {
            return;
        };
        this.factoryInfo = new FactoryInfo();
        this.factoryInfo.factory = _arg1;
        this._loaded = true;
        this._setup = true;
        this._ready = true;
        this._error = false;
        dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
        dispatchEvent(new ModuleEvent(ModuleEvent.PROGRESS));
        dispatchEvent(new ModuleEvent(ModuleEvent.READY));
    }

    public function addReference():void
    {
        this.numReferences++;
    }

    public function removeReference():void
    {
        this.numReferences--;
        if (this.numReferences == 0)
        {
            this.release();
        };
    }

    public function initHandler(_arg1:Event):void
    {
        var _local2:ModuleEvent;
        this.factoryInfo = new FactoryInfo();
        try
        {
            this.factoryInfo.factory = (this.loader.content as IFlexModuleFactory);
        }
        catch(error:Error)
        {
        };
        if (!this.factoryInfo.factory)
        {
            _local2 = new ModuleEvent(ModuleEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
            _local2.bytesLoaded = 0;
            _local2.bytesTotal = 0;
            _local2.errorText = "SWF is not a loadable module";
            dispatchEvent(_local2);
            return;
        };
        this.loader.content.addEventListener("ready", this.readyHandler);
        this.loader.content.addEventListener("error", this.moduleErrorHandler);
        this.loader.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, this.getFlexModuleFactoryRequestHandler, false, 0, true);
        try
        {
            this.factoryInfo.applicationDomain = this.loader.contentLoaderInfo.applicationDomain;
        }
        catch(error:Error)
        {
        };
        this._setup = true;
        dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
    }

    public function progressHandler(_arg1:ProgressEvent):void
    {
        var _local2:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        dispatchEvent(_local2);
    }

    public function completeHandler(_arg1:Event):void
    {
        var _local2:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
        _local2.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        dispatchEvent(_local2);
    }

    public function errorHandler(_arg1:ErrorEvent):void
    {
        this._error = true;
        var _local2:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = 0;
        _local2.bytesTotal = 0;
        _local2.errorText = _arg1.text;
        dispatchEvent(_local2);
    }

    public function getFlexModuleFactoryRequestHandler(_arg1:Request):void
    {
        _arg1.value = this.parentModuleFactory;
    }

    public function readyHandler(_arg1:Event):void
    {
        this._ready = true;
        this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        var _local2:ModuleEvent = new ModuleEvent(ModuleEvent.READY);
        _local2.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
        _local2.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        this.clearLoader();
        dispatchEvent(_local2);
    }

    public function moduleErrorHandler(_arg1:Event):void
    {
        var _local2:ModuleEvent;
        this._ready = true;
        this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        this.clearLoader();
        if ((_arg1 is ModuleEvent))
        {
            _local2 = ModuleEvent(_arg1);
        }
        else
        {
            _local2 = new ModuleEvent(ModuleEvent.ERROR);
        };
        dispatchEvent(_local2);
    }


}
class FactoryInfo 
{

    public var factory:IFlexModuleFactory;
    public var applicationDomain:ApplicationDomain;
    public var bytesTotal:int = 0;


}
class ModuleInfoProxy extends EventDispatcher implements IModuleInfo 
{

    private var info:ModuleInfo;
    private var referenced:Boolean = false;
    private var _data:Object;

    public function ModuleInfoProxy(_arg1:ModuleInfo)
    {
        this.info = _arg1;
        _arg1.addEventListener(ModuleEvent.SETUP, this.moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.PROGRESS, this.moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.READY, this.moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.ERROR, this.moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.UNLOAD, this.moduleEventHandler, false, 0, true);
    }

    public function get data():Object
    {
        return (this._data);
    }

    public function set data(_arg1:Object):void
    {
        this._data = _arg1;
    }

    public function get error():Boolean
    {
        return (this.info.error);
    }

    public function get factory():IFlexModuleFactory
    {
        return (this.info.factory);
    }

    public function get loaded():Boolean
    {
        return (this.info.loaded);
    }

    public function get ready():Boolean
    {
        return (this.info.ready);
    }

    public function get setup():Boolean
    {
        return (this.info.setup);
    }

    public function get url():String
    {
        return (this.info.url);
    }

    public function publish(_arg1:IFlexModuleFactory):void
    {
        this.info.publish(_arg1);
    }

    public function load(_arg1:ApplicationDomain=null, _arg2:SecurityDomain=null, _arg3:ByteArray=null, _arg4:IFlexModuleFactory=null):void
    {
        var _local5:ModuleEvent;
        this.info.resurrect();
        if (!this.referenced)
        {
            this.info.addReference();
            this.referenced = true;
        };
        if (this.info.error)
        {
            dispatchEvent(new ModuleEvent(ModuleEvent.ERROR));
        }
        else
        {
            if (this.info.loaded)
            {
                if (this.info.setup)
                {
                    dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
                    if (this.info.ready)
                    {
                        _local5 = new ModuleEvent(ModuleEvent.PROGRESS);
                        _local5.bytesLoaded = this.info.size;
                        _local5.bytesTotal = this.info.size;
                        dispatchEvent(_local5);
                        dispatchEvent(new ModuleEvent(ModuleEvent.READY));
                    };
                };
            }
            else
            {
                this.info.load(_arg1, _arg2, _arg3, _arg4);
            };
        };
    }

    public function release():void
    {
        if (this.referenced)
        {
            this.info.removeReference();
            this.referenced = false;
        };
    }

    public function unload():void
    {
        this.info.unload();
        this.info.removeEventListener(ModuleEvent.SETUP, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.PROGRESS, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.READY, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.ERROR, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.UNLOAD, this.moduleEventHandler);
    }

    private function moduleEventHandler(_arg1:ModuleEvent):void
    {
        dispatchEvent(_arg1);
    }


}
