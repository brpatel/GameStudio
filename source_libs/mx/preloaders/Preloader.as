//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.preloaders
{
    import flash.display.Sprite;
    import mx.core.mx_internal;
    import flash.utils.Timer;
    import mx.core.RSLListLoader;
    import flash.events.IEventDispatcher;
    import flash.system.ApplicationDomain;
    import mx.core.RSLItem;
    import mx.core.ResourceModuleRSLItem;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import mx.events.FlexEvent;
    import flash.display.LoaderInfo;
    import mx.events.RSLEvent;
    import flash.events.ProgressEvent;
    import flash.events.ErrorEvent;
    import flash.display.MovieClip;

    use namespace mx_internal;

    public class Preloader extends Sprite 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var displayClass:IPreloaderDisplay = null;
        private var timer:Timer;
        private var showDisplay:Boolean;
        private var rslListLoader:RSLListLoader;
        private var resourceModuleListLoader:RSLListLoader;
        private var rslDone:Boolean = false;
        private var loadingRSLs:Boolean = false;
        private var waitingToLoadResourceModules:Boolean = false;
        private var sentDocFrameReady:Boolean = false;
        private var app:IEventDispatcher = null;
        private var applicationDomain:ApplicationDomain = null;
        private var waitedAFrame:Boolean = false;


        public function initialize(_arg1:Boolean, _arg2:Class, _arg3:uint, _arg4:Number, _arg5:Object, _arg6:String, _arg7:Number, _arg8:Number, _arg9:Array=null, _arg10:Array=null, _arg11:Array=null, _arg12:Array=null, _arg13:ApplicationDomain=null):void
        {
            var _local14:int;
            var _local15:int;
            var _local17:RSLItem;
            var _local18:ResourceModuleRSLItem;
            if (((((!((_arg9 == null))) || (!((_arg10 == null))))) && (!((_arg11 == null)))))
            {
                throw (new Error("RSLs may only be specified by using libs and sizes or rslList, not both."));
            };
            this.applicationDomain = _arg13;
            root.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            if (((_arg9) && ((_arg9.length > 0))))
            {
                if (_arg11 == null)
                {
                    _arg11 = [];
                };
                _local14 = _arg9.length;
                _local15 = 0;
                while (_local15 < _local14)
                {
                    _local17 = new RSLItem(_arg9[_local15]);
                    _arg11.push(_local17);
                    _local15++;
                };
            };
            var _local16:Array = [];
            if (((_arg12) && ((_arg12.length > 0))))
            {
                _local14 = _arg12.length;
                _local15 = 0;
                while (_local15 < _local14)
                {
                    _local18 = new ResourceModuleRSLItem(_arg12[_local15], _arg13);
                    _local16.push(_local18);
                    _local15++;
                };
            };
            this.rslListLoader = new RSLListLoader(_arg11);
            if (_local16.length)
            {
                this.resourceModuleListLoader = new RSLListLoader(_local16);
            };
            this.showDisplay = _arg1;
            this.timer = new Timer(10);
            this.timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            this.timer.start();
            if (_arg1)
            {
                this.displayClass = new (_arg2)();
                this.displayClass.addEventListener(Event.COMPLETE, this.displayClassCompleteHandler);
                addChild(DisplayObject(this.displayClass));
                this.displayClass.backgroundColor = _arg3;
                this.displayClass.backgroundAlpha = _arg4;
                this.displayClass.backgroundImage = _arg5;
                this.displayClass.backgroundSize = _arg6;
                this.displayClass.stageWidth = _arg7;
                this.displayClass.stageHeight = _arg8;
                this.displayClass.initialize();
                this.displayClass.preloader = this;
                this.addEventListener(Event.ENTER_FRAME, this.waitAFrame);
            };
            if (this.rslListLoader.getItemCount() > 0)
            {
                this.rslListLoader.load(this.rslProgressHandler, this.rslCompleteHandler, this.rslErrorHandler, this.rslErrorHandler, this.rslErrorHandler);
                this.loadingRSLs = true;
            }
            else
            {
                if (((this.resourceModuleListLoader) && ((this.resourceModuleListLoader.getItemCount() > 0))))
                {
                    if (_arg13.hasDefinition("mx.resources::ResourceManager"))
                    {
                        this.rslListLoader = this.resourceModuleListLoader;
                        this.rslListLoader.load(this.rslProgressHandler, this.rslCompleteHandler, this.rslErrorHandler, this.rslErrorHandler, this.rslErrorHandler);
                    }
                    else
                    {
                        this.waitingToLoadResourceModules = true;
                        this.rslDone = true;
                    };
                }
                else
                {
                    this.rslDone = true;
                };
            };
        }

        public function registerApplication(_arg1:IEventDispatcher):void
        {
            _arg1.addEventListener("validatePropertiesComplete", this.appProgressHandler);
            _arg1.addEventListener("validateSizeComplete", this.appProgressHandler);
            _arg1.addEventListener("validateDisplayListComplete", this.appProgressHandler);
            _arg1.addEventListener(FlexEvent.CREATION_COMPLETE, this.appCreationCompleteHandler);
            this.app = _arg1;
        }

        private function getByteValues():Object
        {
            var _local6:int;
            var _local1:LoaderInfo = root.loaderInfo;
            var _local2:int = _local1.bytesLoaded;
            var _local3:int = _local1.bytesTotal;
            var _local4:int = ((this.rslListLoader) ? this.rslListLoader.getItemCount() : 0);
            var _local5:int;
            while (_local5 < _local4)
            {
                _local2 = (_local2 + this.rslListLoader.getItem(_local5).loaded);
                _local6 = this.rslListLoader.getItem(_local5).total;
                _local3 = (_local3 + _local6);
                _local5++;
            };
            return ({
                loaded:_local2,
                total:_local3
            });
        }

        private function dispatchAppEndEvent(_arg1:Object=null):void
        {
            dispatchEvent(new FlexEvent(FlexEvent.INIT_COMPLETE));
            if (!this.showDisplay)
            {
                this.displayClassCompleteHandler(null);
            };
        }

        mx_internal function rslProgressHandler(_arg1:ProgressEvent):void
        {
            var _local2:int = this.rslListLoader.getIndex();
            var _local3:RSLItem = this.rslListLoader.getItem(_local2);
            var _local4:RSLEvent = new RSLEvent(RSLEvent.RSL_PROGRESS);
            _local4.isResourceModule = (this.rslListLoader == this.resourceModuleListLoader);
            _local4.bytesLoaded = _arg1.bytesLoaded;
            _local4.bytesTotal = _arg1.bytesTotal;
            _local4.rslIndex = _local2;
            _local4.rslTotal = this.rslListLoader.getItemCount();
            _local4.url = _local3.urlRequest;
            dispatchEvent(_local4);
        }

        mx_internal function rslCompleteHandler(_arg1:Event):void
        {
            var _local2:int = this.rslListLoader.getIndex();
            var _local3:RSLItem = this.rslListLoader.getItem(_local2);
            var _local4:RSLEvent = new RSLEvent(RSLEvent.RSL_COMPLETE);
            _local4.isResourceModule = (this.rslListLoader == this.resourceModuleListLoader);
            _local4.bytesLoaded = _local3.total;
            _local4.bytesTotal = _local3.total;
            _local4.loaderInfo = (_arg1.target as LoaderInfo);
            _local4.rslIndex = _local2;
            _local4.rslTotal = this.rslListLoader.getItemCount();
            _local4.url = _local3.urlRequest;
            dispatchEvent(_local4);
            if (((((this.loadingRSLs) && (this.resourceModuleListLoader))) && (((_local2 + 1) == _local4.rslTotal))))
            {
                this.loadingRSLs = false;
                this.waitingToLoadResourceModules = true;
            };
            this.rslDone = ((_local2 + 1) == _local4.rslTotal);
        }

        mx_internal function rslErrorHandler(_arg1:ErrorEvent):void
        {
            var _local2:int = this.rslListLoader.getIndex();
            var _local3:RSLItem = this.rslListLoader.getItem(_local2);
            var _local4:RSLEvent = new RSLEvent(RSLEvent.RSL_ERROR);
            _local4.isResourceModule = (this.rslListLoader == this.resourceModuleListLoader);
            _local4.bytesLoaded = 0;
            _local4.bytesTotal = 0;
            _local4.rslIndex = _local2;
            _local4.rslTotal = this.rslListLoader.getItemCount();
            _local4.url = _local3.urlRequest;
            _local4.errorText = decodeURI(_arg1.text);
            dispatchEvent(_local4);
        }

        private function timerHandler(_arg1:TimerEvent):void
        {
            if (!root)
            {
                return;
            };
            var _local2:Object = this.getByteValues();
            var _local3:int = _local2.loaded;
            var _local4:int = _local2.total;
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _local3, _local4));
            if (this.waitingToLoadResourceModules)
            {
                if (this.applicationDomain.hasDefinition("mx.resources::ResourceManager"))
                {
                    this.waitingToLoadResourceModules = false;
                    this.rslListLoader = this.resourceModuleListLoader;
                    this.rslDone = false;
                    this.rslListLoader.load(this.rslProgressHandler, this.rslCompleteHandler, this.rslErrorHandler, this.rslErrorHandler, this.rslErrorHandler);
                };
            };
            if (((this.rslDone) && ((((((((_local3 >= _local4)) && ((_local4 > 0)))) || ((((_local4 == 0)) && ((_local3 > 0)))))) || ((((((root is MovieClip)) && ((MovieClip(root).totalFrames > 2)))) && ((MovieClip(root).framesLoaded >= 2))))))))
            {
                if (!this.sentDocFrameReady)
                {
                    if (((this.showDisplay) && (!(this.waitedAFrame))))
                    {
                        return;
                    };
                    this.sentDocFrameReady = true;
                    dispatchEvent(new FlexEvent(FlexEvent.PRELOADER_DOC_FRAME_READY));
                    return;
                };
                if (this.waitingToLoadResourceModules)
                {
                    if (this.applicationDomain.hasDefinition("mx.resources::ResourceManager"))
                    {
                        this.waitingToLoadResourceModules = false;
                        this.rslListLoader = this.resourceModuleListLoader;
                        this.rslDone = false;
                        this.rslListLoader.load(this.rslProgressHandler, this.rslCompleteHandler, this.rslErrorHandler, this.rslErrorHandler, this.rslErrorHandler);
                        return;
                    };
                };
                this.timer.removeEventListener(TimerEvent.TIMER, this.timerHandler);
                this.timer.reset();
                dispatchEvent(new Event(Event.COMPLETE));
                dispatchEvent(new FlexEvent(FlexEvent.INIT_PROGRESS));
            };
        }

        private function ioErrorHandler(_arg1:IOErrorEvent):void
        {
        }

        private function displayClassCompleteHandler(_arg1:Event):void
        {
            if (this.displayClass)
            {
                this.displayClass.removeEventListener(Event.COMPLETE, this.displayClassCompleteHandler);
            };
            if (root)
            {
                root.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            };
            if (this.app)
            {
                this.app.removeEventListener("validatePropertiesComplete", this.appProgressHandler);
                this.app.removeEventListener("validateSizeComplete", this.appProgressHandler);
                this.app.removeEventListener("validateDisplayListComplete", this.appProgressHandler);
                this.app.removeEventListener(FlexEvent.CREATION_COMPLETE, this.appCreationCompleteHandler);
                this.app = null;
            };
            dispatchEvent(new FlexEvent(FlexEvent.PRELOADER_DONE));
        }

        private function appCreationCompleteHandler(_arg1:FlexEvent):void
        {
            this.dispatchAppEndEvent();
        }

        private function appProgressHandler(_arg1:Event):void
        {
            dispatchEvent(new FlexEvent(FlexEvent.INIT_PROGRESS));
        }

        private function waitAFrame(_arg1:Event):void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.waitAFrame);
            this.waitedAFrame = true;
        }


    }
}//package mx.preloaders
